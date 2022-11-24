docker build . --tag computer_architecture
docker run -itd --rm --gpus 0 --ipc host -v ${PWD}/result/:/computer_architecture/result/ computer_architecture /bin/bash
