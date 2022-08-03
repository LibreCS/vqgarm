
# start with Ubuntu latest
FROM ubuntu:latest

# update and upgrade
RUN apt update && apt upgrade

# install basic reqs
RUN apt install git
RUN apt install python3 
RUN apt install python3-pip

# setting up env
RUN mkdir /vqgarm
WORKDIR /vqgarm

# cloning repo
RUN git clone https://github.com/LibreCS/vqgarm
RUN cd vqgarm

# installing python library requirements
RUN python3 -m pip install -r requirements

# cloning dependant repos
RUN git clone https://github.com/openai/CLIP
RUN git clone https://github.com/CompVis/taming-transformers

# curling trained imagenet
RUN mkdir checkpoints
RUN curl -L -o checkpoints/vqgan_imagenet_f16_16384.yaml -C - 'https://heibox.uni-heidelberg.de/d/a7530b09fed84f80a887/files/?p=%2Fconfigs%2Fmodel.yaml&dl=1'
RUN curl -L -o checkpoints/vqgan_imagenet_f16_16384.ckpt -C - 'https://heibox.uni-heidelberg.de/d/a7530b09fed84f80a887/files/?p=%2Fckpts%2Flast.ckpt&dl=1'