# HelloCUDA

## Developed by: [Pavia Roberto](https://github.com/bloodsky)

Testing vectors addition with different kernel call:
    
    VectorAdd<<<1,1>>>
    VectorAdd<<<1,256>>>
    VectorAdd<<<num_blocks,256>>>

Each vector is made up of ten million elements. The first example involves a single block consisting of a single thread. It is interesting to consider this case for architectural and performance reasons. The other calls take into account the parallelism of the problem. The number of blocks is calculated based on the size of the vectors.

# Speedup & Profiling
| Attempt | #1  | #2  |
| :---:   | :-: | :-: |
| Seconds | 301 | 283 |

    nvprof

> One block one thread
![alt text](https://github.com/bloodsky/HelloCUDA/blob/main/first.png)
> One block 256 threads
![alt text](https://github.com/bloodsky/HelloCUDA/blob/main/middle.png)
> Multi block 256 threads each
![alt text](https://github.com/bloodsky/HelloCUDA/blob/main/last.png)
