#!/bin/sh -e
# Downloads and runs a release on NixOS.
# Suitable for putting into a systemd service.
# Doesn't deal with upgrades or anything.
DEST=/opt/request_pot
VERSION=$1

mkdir -p $DEST
cd $DEST
if [[ ! -e request_pot-${VERSION}-nixos.tar.gz ]]; then
    wget https://github.com/obmarg/request_pot/releases/download/v${VERSION}/request_pot-${VERSION}-nixos.tar.gz
    tar xvzf request_pot-${VERSION}-nixos.tar.gz
fi
./bin/request_pot foreground
