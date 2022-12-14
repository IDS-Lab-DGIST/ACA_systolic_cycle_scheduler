# ACA_systolic_cycle_scheduler
Multi-user scheduling simulator for submitting Advanced Computer Architecture tasks (DGIST IC606c)  
**Authors : Dahoon Park, Jooyeon Lee, Jahyun Koo, Suengpyo Lee**


## Introduction
This project is based on a docker, so the docker must be installed first.  
Also, we recommend using nvidia-docker with NVIDIA-GPU.  

1. clone this repository
```shell
git clone https://github.com/IDS-Lab-DGIST/ACA_systolic_cycle_scheduler.git
```
2. run docker_run.sh (Use Docker to set up your environment automatically.)
```shell
sh docker_run.sh
```
3. write to network, batch_size, input_shape in model_list.txt
```
# model_list.txt (3 model)
resnet18 10 256 # model_name (timm or huggingface), batch_size, input_shape (image : width,height / nlp : sentence length)
resnet50 10 224
bert-based-uncased 10 256
```
4. write to systolic array in systolic.txt (only generated 3 systolic array)
```
#systolic.txt 
PE's width, PE's height, EA

64 64 3 (64x64 systolic array 3EA)
128 128 1 (128x128 systolic array 1EA)
256 256 1 (256x256 systolic array 1EA)
```

## Demo
### Get GEMM of each network's layer 
#### (saved result in ./ACA2/resource)
```shell
sh run_layer_to_matrix.sh
```
### Compute GEMM's cycle of each systolic layer 
#### (saved ./result/ (cycle_$(modelname)_summary.txt)
```shell
cd ./ACA2/
sh compute_systolic_cycle.sh
```

### scheduling algorithms 
#### (greedy, load balancing greedy. block-wise dijkstra)
```shell
cd /compute_architecture/
python blocksearch.py (blockwise-dijkstra | mode: |avg|std|min|)
python greedy.py (greedy)
python load_balance_greedy.py (load balance greedy)
```

