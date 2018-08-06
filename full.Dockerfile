FROM adnrv/texlive:minimal
MAINTAINER adin

# set up packages
RUN tlmgr update --self &&\
    tlmgr install scheme-full