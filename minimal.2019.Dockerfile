FROM ubuntu:rolling
MAINTAINER adin

ARG YEAR=2019

ENV PATH=/usr/local/texlive/bin/x86_64-linux:$PATH
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./texlive-profile.txt /tmp/
COPY ./debian-equivs.txt /tmp/

# set up packages
RUN apt-get update -qq &&\
    apt-get install --no-install-recommends -y \
      equivs \
      wget \
      perl \
      ca-certificates \
    && \
    \
    # Install texlive
    wget -O /tmp/install-tl-unx.tar.gz https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/"$YEAR"/tlnet-final/install-tl-unx.tar.gz && \
    mkdir /tmp/install-tl && \
    tar -xzf /tmp/install-tl-unx.tar.gz -C /tmp/install-tl --strip-components=1 && \
    /tmp/install-tl/install-tl --profile=/tmp/texlive-profile.txt --repository https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/"$YEAR"/tlnet-final/ && \
    \
    # Install equivalent packages
    cd /tmp && \
    equivs-control texlive-local && \
    equivs-build debian-equivs.txt && \
    dpkg -i texlive-local*.deb && \
    apt-get install -f && \
    \
    # Clean up
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/* 

# Expose /home as workin dir
WORKDIR /home
VOLUME ["/home"]
