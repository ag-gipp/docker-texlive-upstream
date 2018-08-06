FROM adnrv/texlive:minimal
MAINTAINER adin

RUN apt-get update -qq &&\
    apt-get install --no-install-recommends -y \
      libfontconfig1 \
    &&\
    apt-get autoclean &&\
    apt-get autoremove &&\
    rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/* 

# set up packages
RUN tlmgr update --self &&\
    tlmgr install scheme-full