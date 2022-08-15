FROM debian:bullseye-slim

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# hadolint ignore=DL3008
RUN set -x && \
    apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        git \
        libglib2.0-0 \
        libsm6 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxinerama1 \
        libxrandr2 \
        libxrender1 \
        #mercurial \
        openssh-client \
        procps \
        #subversion \
        wget \
        build-essential \
        gfortran \
        zlib1g-dev \
        postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.1.0.tar.gz && tar xzf cfitsio-4.1.0.tar.gz && rm cfitsio-4.1.0.tar.gz && cd /cfitsio-4.1.0 && ./configure --prefix=/usr/local/ && make && make install && ldconfig

RUN git clone https://github.com/mjfitzpatrick/fits2db.git && cd /fits2db && make && make install && cp fits2db /usr/local/bin/

RUN UNAME_M="$(uname -m)" && \
    ANACONDA_URL="https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh"; \
    SHA256SUM="a7c0afe862f6ea19a596801fc138bde0463abcbce1b753e8d5c474b506a2db2d"; \
    wget "${ANACONDA_URL}" -O anaconda.sh -q && \
    echo "${SHA256SUM} anaconda.sh" > shasum && \
    sha256sum --check --status shasum && \
    /bin/bash anaconda.sh -b -p /opt/conda && \
    rm anaconda.sh shasum && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

CMD [ "/bin/bash" ]





