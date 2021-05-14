#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define VECT_SIZE 10000000
#define THRESHOLD 1.e-7

__global__ void VectorAdd(float *w, float *u, float *v, int n) {
    
    int index = threadIdx.x;
    int step = blockDim.x;

    for (int i = index; i < n; i += step) {
        w[i] = u[i] + v[i];
    }
}

void fill(float *v) {
    for (int i = 0; i < VECT_SIZE; i++) {
        v[i] = (float)i;
    }
}

int main() {

    // Host pointers
    float *u, *v, *w;
    // Device pointers
    float *u_device, *v_device, *w_device;

    // Alloco mem host
    u = (float *) malloc(sizeof(float)*VECT_SIZE);
    v = (float *) malloc(sizeof(float)*VECT_SIZE);
    w = (float *) malloc(sizeof(float)*VECT_SIZE);

    fill(u);
    fill(v);

    // Alloco mem device 
    cudaMalloc((void **) &u_device, sizeof(float)*VECT_SIZE);
    cudaMalloc((void **) &v_device, sizeof(float)*VECT_SIZE);
    cudaMalloc((void **) &w_device, sizeof(float)*VECT_SIZE);

    // H --> D
    cudaMemcpy(u_device, u, sizeof(float)*VECT_SIZE, cudaMemcpyHostToDevice); 
    cudaMemcpy(v_device, v, sizeof(float)*VECT_SIZE, cudaMemcpyHostToDevice); 
    
    // Kernel call
    VectorAdd<<<1,256>>>(w_device, u_device, v_device, VECT_SIZE);

    // D --> H
    cudaMemcpy(w, w_device, sizeof(float)*VECT_SIZE, cudaMemcpyDeviceToHost);

    // check ?
    for (int i = 0; i < VECT_SIZE; i++) {
        if (!((w[i]-u[i]-v[i]) < THRESHOLD)) {
            fprintf(stderr,"Got mistake!\n");
        }
    }

    cudaFree(u_device);
    cudaFree(v_device);
    cudaFree(w_device);

    free(u);
    free(v);
    free(w);
}
