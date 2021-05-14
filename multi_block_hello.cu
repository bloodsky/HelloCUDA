#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define VECT_SIZE 10000000
#define THRESHOLD 1.e-7
#define BLOCK_SIZE 256

__global__ void VectorAdd(float *w, float *u, float *v, int n) {
    
    // starting point for each blocks
    int SPFB = blockIdx.x * blockDim.x;
    int TID = SPFB + threadIdx.x;  

    // range checking
    if (TID < n) w[TID] = u[TID] + v[TID];
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

    // Alloco mem device :
    cudaMalloc((void **) &u_device, sizeof(float)*VECT_SIZE);
    cudaMalloc((void **) &v_device, sizeof(float)*VECT_SIZE);
    cudaMalloc((void **) &w_device, sizeof(float)*VECT_SIZE);

    // Trasferisco i dati dall'host area alla device area
    cudaMemcpy(u_device, u, sizeof(float)*VECT_SIZE, cudaMemcpyHostToDevice); 
    cudaMemcpy(v_device, v, sizeof(float)*VECT_SIZE, cudaMemcpyHostToDevice); 
    
    // Kernel call
    int num_blocks = (VECT_SIZE/BLOCK_SIZE) + 1;
    VectorAdd<<<num_blocks,256>>>(w_device, u_device, v_device, VECT_SIZE);

    // Copio dal risultato ottenuto sulla GPU nell'area dell'host
    cudaMemcpy(w, w_device, sizeof(float)*VECT_SIZE, cudaMemcpyDeviceToHost);

    // correct threshold?  
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
