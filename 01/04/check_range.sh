#!/bin/bash

range='^[1-6]$'
if [[ "$1" =~ $range ]] ; then 
    exit 0;
else 
    exit 1;
fi
