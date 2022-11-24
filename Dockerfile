ARG BASE_VERSION=22.08
FROM nvcr.io/nvidia/pytorch:${BASE_VERSION}-py3 as base

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get clean
# this line change to ubuntu archive
RUN apt-get update -y
RUN apt-get install vim -y

RUN pip install timm
RUN pip install yacs
RUN pip install transformers
RUN pip install easydict

RUN mkdir /computer_architecture
WORKDIR /computer_architecture
COPY . /computer_architecture/

ENTRYPOINT ["/opt/nvidia/nvidia_entrypoint.sh"]
