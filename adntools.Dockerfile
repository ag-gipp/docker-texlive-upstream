FROM adnrv/texlive:tools
MAINTAINER adin

# Create the directories
RUN (mkdir -p `kpsewhich -var-value TEXMFHOME`/tex/latex || true) &&\
    (mkdir -p `kpsewhich -var-value TEXMFHOME`/bibtex/bib || true)

RUN \
    # Get the normal repos
    git clone https://gitlab.com/adin/mcv-academic.git `kpsewhich -var-value TEXMFHOME`/tex/latex/mcv-academic &&\
    \
    wget https://gitlab.com/adn-latex/tikz-fa/builds/artifacts/master/download?job=build -O `kpsewhich -var-value TEXMFHOME`/tex/latex/artifacts.zip &&\
    unzip `kpsewhich -var-value TEXMFHOME`/tex/latex/artifacts.zip -d `kpsewhich -var-value TEXMFHOME`/tex/latex/tikz-fa &&\
    rm `kpsewhich -var-value TEXMFHOME`/tex/latex/artifacts.zip &&\
    \
    # Get journal list
    wget https://gitlab.com/adin/journal-list/builds/artifacts/master/download?job=build -O `kpsewhich -var-value TEXMFHOME`/bibtex/bib/artifacts.zip &&\
    unzip `kpsewhich -var-value TEXMFHOME`/bibtex/bib/artifacts.zip -d `kpsewhich -var-value TEXMFHOME`/bibtex/bib/journal-list &&\
    rm `kpsewhich -var-value TEXMFHOME`/bibtex/bib/artifacts.zip &&\
    \
    # Get the adn-latex repos
    git clone https://gitlab.com/adn-latex/adn-latex.git `kpsewhich -var-value TEXMFHOME`/tex/latex/adn-latex &&\
    git clone https://gitlab.com/adn-latex/codetools.git `kpsewhich -var-value TEXMFHOME`/tex/latex/codetools &&\
    git clone https://gitlab.com/adn-latex/adnlogos.git `kpsewhich -var-value TEXMFHOME`/tex/latex/adnlogos &&\
    git clone https://gitlab.com/adn-latex/adnbeamertheme.git `kpsewhich -var-value TEXMFHOME`/tex/latex/adnbeamertheme &&\
    git clone https://gitlab.com/adn-latex/adnarticle.git `kpsewhich -var-value TEXMFHOME`/tex/latex/adnarticle &&\
    git clone https://gitlab.com/adn-latex/beamertools.git `kpsewhich -var-value TEXMFHOME`/tex/latex/beamertools &&\
    git clone https://gitlab.com/adn-latex/adnexam.git `kpsewhich -var-value TEXMFHOME`/tex/latex/adnexam &&\
    git clone https://gitlab.com/adn-latex/adnmemo.git `kpsewhich -var-value TEXMFHOME`/tex/latex/adnmemo &&\
    git clone https://gitlab.com/adn-latex/adnreport.git `kpsewhich -var-value TEXMFHOME`/tex/latex/adnreport &&\
    git clone https://gitlab.com/adn-latex/adnlanguages.git `kpsewhich -var-value TEXMFHOME`/tex/latex/adnlanguages &&\
    git clone https://gitlab.com/adn-latex/adnsyllabus.git `kpsewhich -var-value TEXMFHOME`/tex/latex/adnsyllabus &&\
    \
    # Hash to be sure to find our stuff
    texhash &&\
    \
    # Clean
    apt-get autoclean &&\
    apt-get autoremove &&\
    rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/*
