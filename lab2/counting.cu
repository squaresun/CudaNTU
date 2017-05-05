#include "counting.h"
#include <cstdio>
#include <cassert>
#include <thrust/scan.h>
#include <thrust/transform.h>
#include <thrust/functional.h>
#include <thrust/device_ptr.h>
#include <thrust/execution_policy.h>

const int NUM_THREAD = 1024;

__device__ __host__ int MyCeilDiv(int a, int b) { return (a-2)/b; }	//Index of hierarchy; input[0, n-1]; return [0, n-1]
__device__ __host__ int FloorDivWithTreeIndex(int a, int b) { return a*b + 2; }	//Index of tree; input[0, n-1]; return [0, n-1]
__device__ int FindIndexDevice(int height, int index) { return __double2int_rd(pow(2.0, __int2double_rn(height))) - 2 + index;}	//height starts from 1; index starts from 0

struct IsLetterUnary
{
  __host__ __device__
  int operator()(char x) { return x > '@' ? 1 : 0; }
};

__global__ void mapLetterToBit(const char* text, int *pos, int text_size){
	const int x = blockIdx.x * blockDim.x + threadIdx.x;
	if (x < text_size) {
		pos[x] = IsLetterUnary()(text[x]);
	}
}

__global__ void createTree(int* treePtr, int treeSize, int initPos, int length){
	const int x = blockIdx.x * blockDim.x + threadIdx.x;
	if (x < length) {
		int nextInitPos = FloorDivWithTreeIndex(initPos + x, 2); //Array input index start from 0
		if(treePtr[nextInitPos] == treePtr[nextInitPos + 1] && treePtr[nextInitPos] > 0){
			treePtr[initPos + x] = treePtr[nextInitPos + 1] + treePtr[nextInitPos];
		}
	}
}

__global__ void treeParsing(const int* treePtr, int* posOutput, int initPos, int length, int treeTotalHeight){
	const int x = blockIdx.x * blockDim.x + threadIdx.x;
	if (x < length) {
		int sum = 0;
		int height = treeTotalHeight;
		int nextIndex = initPos + x;
		while(height>1 && treePtr[nextIndex] >= 1 && nextIndex >= FindIndexDevice(height, 0)){
			sum += treePtr[nextIndex] * ((nextIndex + 1) % 2);
			nextIndex = MyCeilDiv(nextIndex, 2) - ((nextIndex + 1) % 2);
			height--;
		}
		if(nextIndex >= FindIndexDevice(height, 0)){
			while(height<=treeTotalHeight){
				if(treePtr[nextIndex] > 0){
					sum += treePtr[nextIndex];
					nextIndex = FloorDivWithTreeIndex(nextIndex, 2) - 1;
				}else{
					nextIndex = FloorDivWithTreeIndex(nextIndex, 2) + 1;
				}
				height++;
			}
		}
		posOutput[x] = sum;
	}
}

void CountPosition1(const char *text, int *pos, int text_size)
{
	thrust::transform(thrust::device, text, text + text_size, pos, IsLetterUnary());
	thrust::inclusive_scan_by_key(thrust::device, pos, pos + text_size, pos, pos, thrust::equal_to<int>());
}

void CountPosition2(const char *text, int *pos, int text_size)
{
	mapLetterToBit<<<(text_size-1)/NUM_THREAD + 1, NUM_THREAD>>>(text, pos, text_size);

	int treeHeight = (int)ceil(log((double)text_size) / log(2.0));

	int treeTotalSize = pow(2, treeHeight) * 2 - 2;
	int textOffset = pow(2, treeHeight) - 2;
	int *gpuTree;
	int *gpuPosOutput;
	cudaMalloc((void**)&gpuTree, sizeof(int) * treeTotalSize);
	cudaMemset(gpuTree, 0, sizeof(int) * treeTotalSize);
	cudaMemcpy(gpuTree + textOffset, pos, sizeof(int) * text_size, cudaMemcpyDeviceToDevice);
	cudaMalloc((void**)&gpuPosOutput, sizeof(int) * text_size);
	cudaMemset(gpuPosOutput, 0, sizeof(int) * text_size);
	for(int i = treeHeight - 1;i>=0;i--){
		int textOffset = pow(2, i) - 2;
		int length = pow(2, i);
		int blockSize = (length-1)/NUM_THREAD + 1;
		createTree<<<blockSize, NUM_THREAD>>>(gpuTree, treeTotalSize, textOffset, length);
	}

	treeParsing<<<(text_size-1)/NUM_THREAD + 1, NUM_THREAD>>>(gpuTree, gpuPosOutput, textOffset, text_size, treeHeight);

	cudaMemcpy(pos, gpuPosOutput, sizeof(int) * text_size, cudaMemcpyDeviceToDevice);

	cudaFree(gpuTree);
	cudaFree(gpuPosOutput);

}