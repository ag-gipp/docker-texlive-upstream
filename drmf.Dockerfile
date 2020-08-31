FROM aggipp/texlive:2018-full-1

RUN apt-get update -qq &&\
    apt-get install --no-install-recommends -y \
      cpanminus \
      libxml2-dev \
      libxslt-dev \
      libxml-libxslt-perl \
      libxml-libxml-perl \
      git \
      default-jdk javacc \
      imagemagick libimage-magick-perl &&\
    apt-get autoclean &&\
    apt-get autoremove &&\
    rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/* 

RUN cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib) && echo 'eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)' >> ~/.bashrc

RUN cpanm https://github.com/brucemiller/LaTeXML.git

RUN cpanm Template YAML

RUN cpanm Template::Toolkit

ADD ./etc /etc
