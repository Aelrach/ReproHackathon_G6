FROM ubuntu:22.04

# Installing dependencies necessary to the use of R
RUN apt-get update && apt-get install -y \
    build-essential \
    libbz2-dev \
    libcurl4-openssl-dev \
    liblzma-dev \
    libreadline6-dev \
    libreadline-dev \
    libssl-dev \
    libx11-dev libxt-dev \
    zlib1g-dev \
    gfortran \
    wget

# Installing correct version of R 
RUN wget https://cran.r-project.org/src/base/R-3/R-3.4.1.tar.gz && \
    tar -zxvf R-3.4.1.tar.gz && \
    cd R-3.4.1 && ./configure --enable-R-shlib && make && make install && \
    R --version

COPY Dockerfile /app/Dockerfile

