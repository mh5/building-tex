FROM debian:stable-slim
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install patch fpc vim zip unzip procps ed tree -y --no-install-recommends && apt-get install wget -y

env TEX_HOME="/root/tex"
env PATH="${PATH}:${TEX_HOME}/distro/bin/"
env PATH="${PATH}:${TEX_HOME}/tex-fpc/shell/"
env PATH="${PATH}:${TEX_HOME}/tex-fpc/MFT/"

COPY prepare-build.sh /tmp/
RUN bash /tmp/prepare-build.sh

COPY local.mf /tmp/
COPY build-mf.sh /tmp/
RUN bash /tmp/build-mf.sh

COPY webmac-memory.patch /tmp/
COPY build-tex.sh /tmp/
COPY tex.sh /root/tex/distro/bin/
RUN chmod a+x /root/tex/distro/bin/tex.sh

RUN bash /tmp/build-tex.sh

