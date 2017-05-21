#include "lab3.h"
#include <cstdio>

__device__ __host__ int CeilDiv(int a, int b) { return (a-1)/b + 1; }
__device__ __host__ int CeilAlign(int a, int b) { return CeilDiv(a, b) * b; }

__global__ void SimpleClone(
	const float *background,
	const float *target,
	const float *mask,
	float *output,
	const int wb, const int hb, const int wt, const int ht,
	const int oy, const int ox
)
{
	const int yt = blockIdx.y * blockDim.y + threadIdx.y;
	const int xt = blockIdx.x * blockDim.x + threadIdx.x;
	const int curt = wt*yt+xt;
	if (yt < ht and xt < wt and mask[curt] > 127.0f) {
		const int yb = oy+yt, xb = ox+xt;
		const int curb = wb*yb+xb;
		if (0 <= yb and yb < hb and 0 <= xb and xb < wb) {
			output[curb*3+0] = target[curt*3+0];
			output[curb*3+1] = target[curt*3+1];
			output[curb*3+2] = target[curt*3+2];
		}
	}
}

__global__ void CalculateFixed(
	const float *background,
	const float *target,
	const float *mask,
	float *fixed,
	const int wb, const int hb, const int wt, const int ht,
	const int oy, const int ox
)
{
	const int yt = blockIdx.y * blockDim.y + threadIdx.y;
	const int xt = blockIdx.x * blockDim.x + threadIdx.x;
	const int yb = oy+yt, xb = ox+xt;
	if (yt < ht and xt < wt and 0 <= yb and yb < hb and 0 <= xb and xb < wb) {
		const int curb = wb*yb+xb;
		const int curt = wt*yt+xt;
		fixed[curt * 3 + 0] = 0.0f;
		fixed[curt * 3 + 1] = 0.0f;
		fixed[curt * 3 + 2] = 0.0f;
		//N
		if(yt - 1 >= 0){
			const int curTargetId = wt * (yt - 1) + xt;
			fixed[curt * 3 + 0] += target[curt * 3 + 0] - target[curTargetId * 3 + 0];
			fixed[curt * 3 + 1] += target[curt * 3 + 1] - target[curTargetId * 3 + 1];
			fixed[curt * 3 + 2] += target[curt * 3 + 2] - target[curTargetId * 3 + 2];
			if(mask[curTargetId] < 127.0f and yb - 1 >= 0){
				const int curBackgroundId = wb * (yb - 1) + xb;
				fixed[curt * 3 + 0] += background[curBackgroundId * 3 + 0];
				fixed[curt * 3 + 1] += background[curBackgroundId * 3 + 1];
				fixed[curt * 3 + 2] += background[curBackgroundId * 3 + 2];
			}
		}
		//W
		if(xt - 1 >= 0){
			const int curTargetId = wt * yt + (xt - 1);
			fixed[curt * 3 + 0] += target[curt * 3 + 0] - target[curTargetId * 3 + 0];
			fixed[curt * 3 + 1] += target[curt * 3 + 1] - target[curTargetId * 3 + 1];
			fixed[curt * 3 + 2] += target[curt * 3 + 2] - target[curTargetId * 3 + 2];
			if(mask[curTargetId] < 127.0f and xb - 1 >= 0){
				const int curBackgroundId = wb * yb + (xb - 1);
				fixed[curt * 3 + 0] += background[curBackgroundId * 3 + 0];
				fixed[curt * 3 + 1] += background[curBackgroundId * 3 + 1];
				fixed[curt * 3 + 2] += background[curBackgroundId * 3 + 2];
			}
		}
		//S
		if(yt + 1 < ht){
			const int curTargetId = wt * (yt + 1) + xt;
			fixed[curt * 3 + 0] += target[curt * 3 + 0] - target[curTargetId * 3 + 0];
			fixed[curt * 3 + 1] += target[curt * 3 + 1] - target[curTargetId * 3 + 1];
			fixed[curt * 3 + 2] += target[curt * 3 + 2] - target[curTargetId * 3 + 2];
			if(mask[curTargetId] < 127.0f and yb + 1 < hb){
				const int curBackgroundId = wb * (yb + 1) + xb;
				fixed[curt * 3 + 0] += background[curBackgroundId * 3 + 0];
				fixed[curt * 3 + 1] += background[curBackgroundId * 3 + 1];
				fixed[curt * 3 + 2] += background[curBackgroundId * 3 + 2];
			}
		}
		//E
		if(xt + 1 < wt){
			const int curTargetId = wt * yt + (xt + 1);
			fixed[curt * 3 + 0] += target[curt * 3 + 0] - target[curTargetId * 3 + 0];
			fixed[curt * 3 + 1] += target[curt * 3 + 1] - target[curTargetId * 3 + 1];
			fixed[curt * 3 + 2] += target[curt * 3 + 2] - target[curTargetId * 3 + 2];
			if(mask[curTargetId] < 127.0f and xb + 1 < wb){
				const int curBackgroundId = wb * yb + (xb + 1);
				fixed[curt * 3 + 0] += background[curBackgroundId * 3 + 0];
				fixed[curt * 3 + 1] += background[curBackgroundId * 3 + 1];
				fixed[curt * 3 + 2] += background[curBackgroundId * 3 + 2];
			}
		}
	}
}

__global__ void PoissonImageCloningIteration(
	const float *fixed,
	const float *mask,
	const float *inputBuf,
	float *outputBuf,
	const int wt, const int ht
)
{
	const int yt = blockIdx.y * blockDim.y + threadIdx.y;
	const int xt = blockIdx.x * blockDim.x + threadIdx.x;
	if (yt < ht and xt < wt) {
		float fractionSum = 0;
		const int curt = wt*yt+xt;
		outputBuf[curt * 3 + 0] = fixed[curt * 3 + 0];
		outputBuf[curt * 3 + 1] = fixed[curt * 3 + 1];
		outputBuf[curt * 3 + 2] = fixed[curt * 3 + 2];

		//N
		if(yt - 1 >= 0){
			const int curTargetId = wt * (yt - 1) + xt;
			if(mask[curTargetId] > 127.0f){
				outputBuf[curt * 3 + 0] += inputBuf[curTargetId * 3 + 0];
				outputBuf[curt * 3 + 1] += inputBuf[curTargetId * 3 + 1];
				outputBuf[curt * 3 + 2] += inputBuf[curTargetId * 3 + 2];
			}
			fractionSum += 1.0f;
		}
		//W
		if(xt - 1 >= 0){
			const int curTargetId = wt * yt + (xt - 1);
			if(mask[curTargetId] > 127.0f){
				outputBuf[curt * 3 + 0] += inputBuf[curTargetId * 3 + 0];
				outputBuf[curt * 3 + 1] += inputBuf[curTargetId * 3 + 1];
				outputBuf[curt * 3 + 2] += inputBuf[curTargetId * 3 + 2];
			}
			fractionSum += 1.0f;
		}
		//S
		if(yt + 1 < ht){
			const int curTargetId = wt * (yt + 1) + xt;
			if(mask[curTargetId] > 127.0f){
				outputBuf[curt * 3 + 0] += inputBuf[curTargetId * 3 + 0];
				outputBuf[curt * 3 + 1] += inputBuf[curTargetId * 3 + 1];
				outputBuf[curt * 3 + 2] += inputBuf[curTargetId * 3 + 2];
			}
			fractionSum += 1.0f;
		}
		//E
		if(xt + 1 < wt){
			const int curTargetId = wt * yt + (xt + 1);
			if(mask[curTargetId] > 127.0f){
				outputBuf[curt * 3 + 0] += inputBuf[curTargetId * 3 + 0];
				outputBuf[curt * 3 + 1] += inputBuf[curTargetId * 3 + 1];
				outputBuf[curt * 3 + 2] += inputBuf[curTargetId * 3 + 2];
			}
			fractionSum += 1.0f;
		}
		//   answer/fractionSum
		outputBuf[curt * 3 + 0] /= fractionSum;
		outputBuf[curt * 3 + 1] /= fractionSum;
		outputBuf[curt * 3 + 2] /= fractionSum;
	}
}

void PoissonImageCloning(
	const float *background,
	const float *target,
	const float *mask,
	float *output,
	const int wb, const int hb, const int wt, const int ht,
	const int oy, const int ox
)
{
	// set up
	float *fixed, *buf1, *buf2;
	cudaMalloc(&fixed, 3*wt*ht*sizeof(float));
	cudaMalloc(&buf1, 3*wt*ht*sizeof(float));
	cudaMalloc(&buf2, 3*wt*ht*sizeof(float));
	// initialize the iteration
	dim3 gdim(CeilDiv(wt,32), CeilDiv(ht,16)), bdim(32,16);
	CalculateFixed<<<gdim, bdim>>>(
		background, target, mask, fixed,
		wb, hb, wt, ht, oy, ox
	);
	cudaMemcpy(buf1, target, sizeof(float)*3*wt*ht, cudaMemcpyDeviceToDevice);
	// iterate
	for(int i=0;i<10000;++i){
		PoissonImageCloningIteration<<<gdim, bdim>>>(
	    	fixed, mask, buf1, buf2, wt, ht
	   	);
	   	PoissonImageCloningIteration<<<gdim, bdim>>>(
	    	fixed, mask, buf2, buf1, wt, ht
		);
	}
	//copy the image back
	cudaMemcpy(output, background, wb*hb*sizeof(float)*3, cudaMemcpyDeviceToDevice);
	SimpleClone<<<gdim, bdim>>>(
		background, buf1, mask, output,
		wb, hb, wt, ht, oy, ox
	);
	//clean up
	cudaFree(fixed);
	cudaFree(buf1);
	cudaFree(buf2);
}