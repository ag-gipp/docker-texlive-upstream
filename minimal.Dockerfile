FROM ubuntu:rolling
MAINTAINER adin

ENV PATH=/usr/local/texlive/bin/x86_64-linux:$PATH

COPY ./texlive-profile.txt /tmp/
COPY ./debian-equivs.txt /tmp/texlive-local

# set up packages
RUN apt-get update -qq &&\
    apt-get install --no-install-recommends -y \
      equivs \
      wget \
      perl \
    && \
    \
    # Install texlive
    wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    mkdir /tmp/install-tl && \
    tar -xzf install-tl-unx.tar.gz -C /tmp/install-tl --strip-components=1 && \
    /tmp/install-tl/install-tl --profile=/tmp/texlive-profile.txt && \
    \
    # Install equivalent packages
    cd /tmp && \
    equivs-control texlive-local && \
    equivs-build texlive-local && \
    dpkg -i texlive-local_2019-1_all.deb && \
    apt-get install -f && \
    \
    # Clean up
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/* \
           install-tl-unx.tar.gz

# Expose /home as workin dir
WORKDIR /home
VOLUME ["/home"]
