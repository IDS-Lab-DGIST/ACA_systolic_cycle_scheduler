docker build . --tag computer_architecture
docker rm -f ca_container
docker run -itd --rm --ipc host -p 12341:12341 -p 8888:8888 -v ${PWD}/result/:/computer_architecture/result/ --name ca_container computer_architecture /bin/bash
docker exec -it ca_container /bin/bash

