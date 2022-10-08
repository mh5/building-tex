#!/usr/bin/env sh
ln -fs $TEX_HOME/distro/TeXformats .
ln -fs $TEX_HOME/distro/TeXfonts .
tex "$@"

