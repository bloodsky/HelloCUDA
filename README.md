# HelloCUDA

## Developed by: [Pavia Roberto](https://github.com/bloodsky)

Testing vectors addition with different kernel call:
    
    VectorAdd<<<1,1>>>
    VectorAdd<<<1,m>>>
    VectorAdd<<<n,m>>>

Each vector is made up of ten million elements. The first example involves a single block consisting of a single thread. It is interesting to consider this case for architectural and performance reasons. The other calls take into account the parallelism of the problem. The number of blocks is calculated based on the size of the vectors.

# Speedup & Profiling

The following improvements are achieved:  
  
![equation](https://latex.codecogs.com/svg.latex?%5Cleft%20%28%201%2C1%20%5Cright%20%29%5Crightarrow%20%5Cleft%20%28%201%2Cm%20%5Cright%20%29%5Capprox%2039)  
![equation](https://latex.codecogs.com/svg.latex?%5Cleft%20%28%201%2Cm%20%5Cright%20%29%5Crightarrow%20%5Cleft%20%28%20n%2Cm%20%5Cright%20%29%5Capprox%2041)  
![equation](https://latex.codecogs.com/svg.latex?%5Cleft%20%28%201%2C1%20%5Cright%20%29%5Crightarrow%20%5Cleft%20%28%20n%2Cm%20%5Cright%20%29%5Capprox%201523)  

    nvprof

> One block one thread
![alt text](https://github.com/bloodsky/HelloCUDA/blob/main/first.png)
> One block 256 threads
![alt text](https://github.com/bloodsky/HelloCUDA/blob/main/middle.png)
> Multi block 256 threads each
![alt text](https://github.com/bloodsky/HelloCUDA/blob/main/last.png)
