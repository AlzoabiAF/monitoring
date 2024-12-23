#!/bin/bash

re='^[0-9]+$'
if [[ $# == "1" && ! $1 =~ $re ]] ; then 
    echo "$1" ;
else
    echo "error"; exit 1
fi
