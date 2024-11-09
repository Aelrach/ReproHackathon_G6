FROM ubuntu:22.04

RUN apt-get update && apt-get install -y default-jre perl wget unzip
RUN java -version

RUN wget -O fastqc.zip https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip && \
    unzip fastqc.zip && \
    cd FastQC && chmod 755 fastqc && \
    mv /FastQC /usr/local/bin/FastQC

ENV PATH="/usr/local/bin/FastQC:$PATH"

RUN fastqc - version