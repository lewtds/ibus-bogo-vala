#!/bin/bash

cd build
make

cd ..

IBUS_HOME=/usr/lib/ibus-bogo
IBUS_DATA=/usr/share/ibus
BOGO_DATA=/usr/share/ibus-bogo

if [ ! -d $IBUS_HOME ]; then
    mkdir -p $IBUS_HOME
fi

cp ./build/src/ibus-engine-bogo $IBUS_HOME/ibus-engine-bogo
cp ./src/bogo.xml.in.in $IBUS_DATA/component/bogo.xml
if [ ! -d $BOGO_DATA/icons ]; then
    mkdir -p $BOGO_DATA/icons
fi
cp ./icons/bogo-icons.svg $BOGO_DATA/icons/bogo-icons.svg
