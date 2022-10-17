#!/usr/bin/env bash
set -e

mkdir -p "$TEX_HOME"
cd "$TEX_HOME"

# get the source files
wget --no-verbose http://mirrors.ctan.org/systems/knuth/dist.zip
wget --no-verbose http://mirrors.ctan.org/systems/knuth/local.zip
wget --no-verbose http://mirrors.ctan.org/systems/unix/tex-fpc.zip
for i in *.zip; do unzip -q $i; done
rm *.zip

# base folders that will be required for metafont and tex
mkdir distro
cd distro
mkdir -p TeXinputs TeXformats TeXfonts MFbases MFinputs bin

cd "$TEX_HOME"
cp -r dist/* tex-fpc

# build tangle, which converts .web + .ch files into Pascal files
fpc ./tex-fpc/tangle.p
mv tex-fpc/tangle distro/bin/

# build weave, which converts .web + .ch files into .tex files
cd $TEX_HOME/tex-fpc/web
cp ../weave.ch .
../ch.ch/mkprod weave
tgl weave.web weave.ch
mv weave ../../distro/bin/

