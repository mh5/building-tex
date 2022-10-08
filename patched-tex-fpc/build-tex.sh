#!/usr/bin/env bash
set -e

# build initex (an initialization version of tex, which supports the dump command to create formats)
cd $TEX_HOME
itgl ./tex-fpc/tex/tex.web  ./tex-fpc/tex.ch
mv tex.pool distro/TeXformats/
mv initex distro/bin/

# create the plain format (uses the dump command from initex)
cd $TEX_HOME/
cp ./tex-fpc/lib/hyphen.tex distro/TeXinputs/
cd ./tex-fpc/tex
ln -s ../../distro/TeXformats/ .
ln -s ../../distro/TeXfonts/ .
ln -s ../../distro/TeXinputs/ .
initex ../lib/plain \\dump
mv plain.fmt TeXformats/

# build the production version of tex
cd $TEX_HOME/tex-fpc/tex
cp ../tex.ch .
../ch.ch/mkprod tex
tgl tex.web tex.ch
mv tex ../../distro/bin/

# add the webmac files and apply the patch by Joachim Kuebart
cd $TEX_HOME/distro
cp ../tex-fpc/webmac-fpc.tex ./TeXinputs/
cp ../tex-fpc/lib/webmac.tex ./TeXinputs/
patch ./TeXinputs/webmac.tex -i /tmp/webmac-memory.patch

# build the tex.dvi document
cd $TEX_HOME/distro
weave ../tex-fpc/tex/tex.web ../tex-fpc/tex/tex.ch tex.tex
tex tex.tex

# list the files in your distro
tree



