FROM rocker/r-ver:3.6.1

RUN echo "deb http://archive.debian.org/debian/ stretch contrib main non-free" > /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get install -y apt-utils
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get install -y --no-install-recommends libcurl4-openssl-dev libxml2-dev zlib1g-dev libssl-dev libpng-dev

RUN Rscript -e "install.packages('https://cloud.r-project.org/src/contrib/Archive/BiocManager/BiocManager_1.30.4.tar.gz', repos = NULL, type = 'source')" && \
    Rscript -e "BiocManager::install(version='3.9', ask = FALSE)" && \
    mkdir -p /usr/local/lib/R/etc && \
    echo '# Configure a CRAN snapshot compatible with Bioconductor 3.9: \n options(repos = c(CRAN = "https://packagemanager.posit.co/cran/2019-03-04"))' > /usr/local/lib/R/etc/Rprofile.site

# Verify installation
RUN R --version
RUN Rscript -e "BiocManager::install(c('stringr', 'ggplot2', 'ggrepel', 'dplyr'))"
RUN Rscript -e 'BiocManager::install("KEGGREST")'

#Required for the execution of nextflow process
RUN apt-get install -y procps gawk sed coreutils grep

ENTRYPOINT ["/bin/bash"]