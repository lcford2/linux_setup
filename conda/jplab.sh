#!/bin/bash

if [ $# -eq 0 ]
then
    dir="./"
else
    dir=$1
fi

jupyter lab --no-browser --ip "*" --notebook-dir $dir > /dev/null 2>&1 &

