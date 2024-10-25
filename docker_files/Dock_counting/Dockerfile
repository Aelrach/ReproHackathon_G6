FROM ubuntu:22.04

## Install dependencies 
RUN apt-get update && apt-get install -y \
    build-essential \
    wget

## Install featureCounts
RUN wget https://sourceforge.net/projects/subread/files/subread-1.4.6-p3/subread-1.4.6-p3-Linux-x86_64.tar.gz/download -O subread-1.4.6-p3-Linux-x86_64.tar.gz && \
    tar -xvzf subread-1.4.6-p3-Linux-x86_64.tar.gz && \
    mv subread-1.4.6-p3-Linux-x86_64/bin/* /usr/local/bin/ && \
    featureCounts -v


COPY Dockerfile /app/Dockerfile
