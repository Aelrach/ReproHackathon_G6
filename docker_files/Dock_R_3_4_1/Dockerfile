FROM rocker/r-ver:3.4.1
RUN echo "deb http://archive.debian.org/debian/ stretch contrib main non-free" > /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends libcurl4-openssl-dev libxml2-dev zlib1g-dev

RUN Rscript -e 'install.packages("BiocInstaller", repos="https://bioconductor.org/packages/3.5/bioc")' && \
    mkdir -p /usr/local/lib/R/etc && \
    echo '# Configure a CRAN snapshot compatible with Bioconductor 3.5: \n options(repos = c(CRAN = "https://packagemanager.posit.co/cran/2017-10-30"))' > /usr/local/lib/R/etc/Rprofile.site

# Verify installation
RUN R --version

# For several packages, these need to be installed
RUN Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/rlang/rlang_0.4.0.tar.gz', repos = NULL, type = 'source')" && \
    Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/cpp11/cpp11_0.1.0.tar.gz', repos = NULL, type = 'source')" && \
    Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/XML/XML_3.98-1.9.tar.gz', repos = NULL, type = 'source')"

#RCurl and dependencies
RUN Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/bitops/bitops_1.0-6.tar.gz', repos = NULL, type = 'source')" && \
    Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/RCurl/RCurl_1.95-4.9.tar.gz', repos = NULL, type = 'source')"

# For vctrs to be installed
RUN Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/backports/backports_1.1.2.tar.gz', repos = NULL, type = 'source')" && \
    Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/digest/digest_0.6.13.tar.gz', repos = NULL, type = 'source')" && \
    Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/glue/glue_1.2.0.tar.gz', repos = NULL, type = 'source')" && \
    Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/zeallot/zeallot_0.0.6.tar.gz', repos = NULL, type = 'source')" && \
    Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/ellipsis/ellipsis_0.0.1.tar.gz', repos = NULL, type = 'source')" && \
    Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/vctrs/vctrs_0.2.1.tar.gz', repos = NULL, type = 'source')"

# For proper installation of other packages
RUN Rscript -e 'BiocInstaller::biocLite("GenomeInfoDb")' && \
    Rscript -e "BiocInstaller::biocLite(c('locfit', 'ggplot2', 'Hmisc', 'fastmap', 'cachem', 'blob', 'memoise', 'RSQLite', 'AnnotationDbi', 'annotate', 'genefilter', 'geneplotter', 'Rcpp', 'RcppArmadillo'))" && \
    Rscript -e "BiocInstaller::biocLite(c('stringi', 'stringr', 'dplyr', 'readxl'))" && \
    Rscript -e 'BiocInstaller::biocLite("DESeq2")'

# Check Installation
RUN Rscript -e 'library("DESeq2")'