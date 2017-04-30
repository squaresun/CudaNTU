#include "counting.h"
#include <cstdio>
#include <cassert>
#include <thrust/scan.h>
#include <thrust/transform.h>
#include <thrust/functional.h>
#include <thrust/device_ptr.h>
#include <thrust/execution_policy.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////
#include <thrust/for_each.h>

struct printf_functor
{
  __host__ __device__
  void operator()(int x)
  {
    // note that using printf in a __device__ function requires
    // code compiled for a GPU with compute capability 2.0 or
    // higher (nvcc --arch=sm_20)
    printf("%d\n", x);
  }
  __host__ __device__
  void operator()(char x)
  {
    // note that using printf in a __device__ function requires
    // code compiled for a GPU with compute capability 2.0 or
    // higher (nvcc --arch=sm_20)
    printf("%c", x);
  }
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////

const int NUM_THREAD = 1024;

__device__ __host__ int CeilDiv(int a, int b) { return (a-1)/b + 1; }
__device__ __host__ int CeilAlign(int a, int b) { return CeilDiv(a, b) * b; }

struct IsLetterUnary
{
  __host__ __device__
  int operator()(char x) { return x > '@' ? 1 : 0; }
};

__global__ void mapLetterToBit(const char* text, int *pos, int text_size){
	// const int y = blockIdx.y * blockDim.y + threadIdx.y;
	const int x = blockIdx.x * blockDim.x + threadIdx.x;
	if (x < text_size) {
		pos[x] = IsLetterUnary()(text[x]);
	}
}

__global__ void segmentedPrefixSum(const char* text, int *pos, int text_size){
	// const int y = blockIdx.y * blockDim.y + threadIdx.y;
	const int x = blockIdx.x * blockDim.x + threadIdx.x;
	if (x < text_size) {
		
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
	segmentedPrefixSum<<<(text_size-1)/NUM_THREAD + 1, NUM_THREAD>>>(text, pos, text_size);
}
