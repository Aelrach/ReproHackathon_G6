FROM ubuntu:22.04
RUN apt-get update && apt-get install -y wget && apt-get install -y unzip

# Manually install bowtie 0.12.7
RUN mkdir /bowtie && cd /bowtie && \
    wget https://sourceforge.net/projects/bowtie-bio/files/bowtie/0.12.7/bowtie-0.12.7-linux-x86_64.zip/download -O bowtie.zip && \
    unzip bowtie.zip && \
    rm bowtie.zip
ENV PATH="/bowtie/bowtie-0.12.7:$PATH"

# Install samtools
RUN apt-get install -y samtools

# Installation check
RUN bowtie --version
RUN samtools --version