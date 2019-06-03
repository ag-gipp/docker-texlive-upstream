FROM adnrv/texlive:minimal
MAINTAINER adin

RUN   tlmgr update --self &&\
      tlmgr install \
      # Collections of basic stuff
      collection-basic \
      collection-fontsrecommended \
      collection-latex \
      collection-latexrecommended \
      collection-latexextra \
      collection-langkorean \
      collection-langspanish \
      collection-langportuguese \
      collection-luatex \
      collection-mathscience \
      \
      # Other packages
      biber \
      biblatex \
      biblatex-ieee \
      doublestroke \
      erewhon \
      fontawesome \
      fontawesome5 \
      fourier \
      genmisc \
      inconsolata \
      IEEEtran \
      latexmk \
      listofitems \
      logreq \
      ly1 \
      siunitx \
      tracklang \
      xcite
