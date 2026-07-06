FROM ubuntu:22.04 AS base

#get the target architecture
ARG TARGETARCH

#get parallel and bash stuff
RUN apt-get update
RUN apt-get install -y bash wget file git

RUN echo "achitecture found: $TARGETARCH"

#taken from mlstfinder build
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        MINICONDAURL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"; \
    else \
        MINICONDAURL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"; \
    fi && wget --quiet "$MINICONDAURL" -O /miniconda.sh

# install with -b (non-interactive) to path /opt/conda and rm installer
RUN bash /miniconda.sh -b -p /opt/miniconda
RUN rm /miniconda.sh

#adding miniconda to path
ENV PATH="/opt/miniconda/bin:$PATH"

#accept terms of service
RUN conda tos accept --channel https://repo.anaconda.com/pkgs/main

#Install on arm64
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        conda install -y -c bioconda isescan; \
    else \
        conda install -y -c bioconda isescan; \
    fi

#working dir
WORKDIR /src
COPY . /src


CMD ["bash", "/src/run_ISEScan_test.sh"]



