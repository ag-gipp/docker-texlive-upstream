[![pipeline status](https://gitlab.com/docker-hub/texlive/badges/master/pipeline.svg)](https://gitlab.com/docker-hub/texlive/commits/master)
[![Docker hub](https://img.shields.io/docker/pulls/adnrv/texlive.svg)](https://hub.docker.com/r/adnrv/texlive)
[![Docker Stars](https://img.shields.io/docker/stars/adnrv/texlive.svg)](https://hub.docker.com/r/adnrv/texlive)

# Texlive Docker Container 

This is a set of containers over TeXLive that are automatically build using [GitLab](https://gitlab.com/docker-hub/texlive) and pushed into a public [docker hub repo](https://hub.docker.com/r/adnrv/texlive/).

## Types of containers

All versions of the containers are based on `ubuntu:rolling` (see the [tags](https://hub.docker.com/r/adnrv/texlive/tags/) for the published list).

### Vanilla Containers

These containers are the installation of the TeXLive script over docker.

- [Minimal (adnrv/texlive:minimal)](minimal.Dockerfile) is the minimal scheme of TeXLive (you can use it to extend your own custom images).
- [Basic (adnrv/texlive:basic)](basic.Dockerfile) is the basic scheme of TeXLive (you can use it to extend your own custom images) extended over the `minimal` container.

### Custom Containers

Other containers that are tunned to writing papers, proposal, and other academic documents need more specialized tools over TeXLive for a productive flow. The provided images (that work for me and my team) are below.

- [Custom (adnrv/texlive:custom)](custom.Dockerfile) is an extension over the `minimal` container that installs the basic packages plus some other non-basic ones. It is a middle ground between basic and full.
- [Tools (adnrv/texlive:tools)](tools.Dockerfile) is an extension over the `custom` container that provides useful tools to build and execute more complex documents.
- [adnTools (adnrv/texlive:adntools)](adntools.Dockerfile) is an extension over the `tools` container that packages all my [(La)TeX libraries](https://gitlab.com/adn-latex) into a single container.
- [adnAMC (adnrv/texlive:adnamc)](adnamc.Dockerfile) is an extension over the `adntools` container that provides the [Auto Multiple Choice package](https://www.auto-multiple-choice.net/) with [my libraries](https://gitlab.com/adn-latex/adnamc) to use it. This is provided outside of `adntools` due to its large size.

# Containers Usage

In the examples below the image `adnrv/texlive` can be change by adding the tag `:tag` to the name (see available [images](#types-of-containers)).

## See available tex binaries

```shell
docker run --rm adnrv/texlive ls -lah /opt/texbin/
```

## Build `tex` documents

Use 

```shell
docker run --rm -it -v "$(pwd)":/home adnrv/texlive pdflatex document.tex
```

or any other engine, such as `xelatex` or `lualatex`. In case you want to pass your user and group that can be achieved with 

```shell
docker run --rm -it --user="$(id -u):$(id -g)" -v "$(pwd)":/home adnrv/texlive pdflatex document.tex
```

# Build Images

In case you want to build the images you can

```shell
docker build -t texlive:tag -f tag.Dockerfile .
```

where the `tag` refers to the type of the you.Dockerfile want to build.

## Extend the Images

If you need some software of extra packages you can customize your own images using these ones as base.

You need to create a `Dockerfile` like the following

```docker
FROM adnrv/texlive:tag

# Minted + Pygments
RUN tlmgr update --self && \
    tlmgr install minted
```

Note that when using `tlmgr` to avoid crashes on updates, doing a `update --self` is useful before using the command.