#!/bin/sh
rm rel/relx.config

MIX_ENV=prod mix compile
MIX_ENV=prod mix release
cp rel/request_pot/releases/${TRAVIS_TAG:1}/request_pot.tar.gz request_pot-${TRAVIS_TAG:1}-ubuntu.tar.gz

rm -R rel/request_pot
echo "{include_erts, false}.\n" > rel/relx.config
MIX_ENV=prod mix release
cp rel/request_pot/releases/${TRAVIS_TAG:1}/request_pot.tar.gz request_pot-${TRAVIS_TAG:1}-nixos.tar.gz
