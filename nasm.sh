#!/bin/bash

PWD=`dirname $0`
source $PWD/build.sh

clean
buildNASM
run
