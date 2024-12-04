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

# Téléchargement de la bonne version de R : 3.6.1 
RUN curl -o R_3-6-1.tar.gz https://cran.rstudio.com/src/base/R-3/R-3.6.1.tar.gz && tar -xzf R_3-6-1.tar.gz && rm R_3-6-1.tar.gz 

# Installation 
RUN cd R-3.6.1/ && ./configure && make && make install

# Installation de BiocManager
RUN Rscript -e "install.packages('https://cloud.r-project.org/src/contrib/Archive/BiocManager/BiocManager_1.30.4.tar.gz', repos = NULL, type = 'source')" && \
    Rscript -e "BiocManager::install(version='3.9', ask = FALSE)" && \
    mkdir -p /usr/local/lib/R/etc && \
    echo '# Configure a CRAN snapshot compatible with Bioconductor 3.9: \n options(repos = c(CRAN = "https://packagemanager.posit.co/cran/2019-03-04"))' > /usr/local/lib/R/etc/Rprofile.site

RUN Rscript -e "BiocManager::install(c('stringr', 'ggplot2', 'ggrepel', 'dplyr'))"
RUN Rscript -e 'BiocManager::install("KEGGREST")'

# Verify installation
RUN R --version
RUN Rscript -e "library('KEGGREST')"

