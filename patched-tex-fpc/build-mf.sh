#!/usr/bin/env bash
set -e

# build inimf (the initialization version of metafont, which supports the dump command)
cd "$TEX_HOME"
itgl ./tex-fpc/mf/mf.web ./tex-fpc/mf.ch
mv mf.pool distro/MFbases/
mv inimf distro/bin/

# build plain.base (base files to metafont are like format files to tex)
# also note the use of the inimf dump command
cd "$TEX_HOME"
cp /tmp/local.mf tex-fpc/MFT/
cd distro
inimf ../tex-fpc/lib/plain input ../tex-fpc/MFT/local dump
mv plain.base MFbases/

# build the production version of metafont
cd $TEX_HOME/tex-fpc/mf/
cp ../mf.ch .
../ch.ch/mkprod mf
tgl mf.web mf.ch
mv mf ../../distro/bin/

# get the source font files
cd $TEX_HOME
mv local/cm/*mf local/lib/*mf distro/MFinputs/
cp tex-fpc/lib/manfnt.mf distro/MFinputs/
cp tex-fpc/lib/logo10.mf distro/MFinputs/
cp tex-fpc/lib/logo.mf distro/MFinputs/

# use metafont to build the fonts that are required for plain.fmt
cd $TEX_HOME/tex-fpc/cm/
ln -s ../../distro/MFbases/ .
ln -s ../../distro/MFinputs/ .
ln -s ../../distro/TeXfonts/ .
plainfonts
manfonts
webfonts

cd $TEX_HOME/distro/
mkfont manfnt
mkfont logo10
