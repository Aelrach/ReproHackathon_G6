# Image initiale avec ubuntu
FROM ubuntu:20.04 

# Pour ne pas avoir de fenetre interactive qui pop lors de l'installation des librairies 
ENV DEBIAN_FRONTEND=noninteractive

# Installation des dépendences nécessaires 
RUN apt-get update 
RUN apt-get install -y  \
curl \
make \
zlib1g-dev  \
zlib1g  \
gfortran  \
g++  \
gcc  \
aptitude  \
fort77  \
libbz2-dev  \
liblzma-dev  \
libpcre3  \
libpcre3-dev  \
libcurl4  \
libcurl4-openssl-dev  \
default-jdk  \
texlive-latex-base  \
libxml2-dev  \
libpng-dev  \
graphviz  \
libgraphviz-dev  \
libssl-dev \
r-base-dev \
libcairo-dev

# Installation des dépendences nécessaires
RUN aptitude install -y libreadline-dev

# Téléchargement de la bonne version de R : 3.4.1 
RUN curl -o R_3-4-1.tar.gz https://cran.rstudio.com/src/base/R-3/R-3.4.1.tar.gz && tar -xzf R_3-4-1.tar.gz && rm R_3-4-1.tar.gz 

# Installation 
RUN cd R-3.4.1/ && ./configure && make && make install

# Installation de packages 
RUN R -e "install.packages(c('tidyverse','ggrepel', 'pheatmap', 'Cairo') , repos = 'https://packagemanager.posit.co/cran/__linux__/focal/2018-01-11')"

# Installation de BiocInstaller (c'est l'ancêtre de BiocManager qui était la seule option pour utiliser Bioconductor à l'époque)
RUN R -e "install.packages('BiocInstaller', repos = 'https://bioconductor.org/packages/3.5/bioc/')"

# Installation des dépendences de Rgraphviz
RUN R -e "BiocInstaller::biocLite('graph')"

# Téléchargement de Rgraphviz à la source 
# Ce package est problématique à installer ne utilisant biocLite (il a du mal à trouver un header file), cette manière d'installer résout le problème
RUN curl -O https://www.bioconductor.org/packages/release/bioc/src/contrib/Rgraphviz_2.50.0.tar.gz && tar -xzf Rgraphviz_2.50.0.tar.gz && rm Rgraphviz_2.50.0.tar.gz

# Installation depuis la source
RUN R -e "install.packages('Rgraphviz/', repos = NULL, type='source')" && rm -rf Rgraphviz

# Installation de EnrichmentBrowser et DESeq2 (qui est une dépendence de EnrichmentBrowser)
# Les version sont : DESeq2 1.16.1
RUN R -e "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/focal/2018-01-11')) ; BiocInstaller::biocLite('DESeq2')"

RUN Rscript -e 'library("DESeq2")'

