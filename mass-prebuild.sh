#!/bin/bash

set -x

rm -rf ~/.cache/copr/*

mkdir -p ~/.config
cat $COPR_CONFIG > ~/.config/copr

cp -r .mpb ~/
copr-cli whoami
mpb 

exit 0
