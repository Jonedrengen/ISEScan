#base image from ubuntu

FROM ubuntu:22.04

#installing dependencies
RUN apt-get update && apt-get install -y python3 python3-pip wget git bzip2

#Intall conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

# accept conda license
RUN /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
RUN /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# creating conda env and installing isescan
RUN /opt/conda/bin/conda create -n isescan_env -c bioconda -c conda-forge python=3.10 isescan -y

# place in path
ENV PATH=/opt/conda/envs/isescan_env/bin:$PATH

# entrypoint is the isescan.py script
ENTRYPOINT [ "isescan.py" ]
