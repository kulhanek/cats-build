#!/bin/bash

echo ""
if [ -z "$*" ]; then
    echo "Clean mode: simple"
else
    echo "Clean mode: $*"
fi

cat repositories | grep -v '^#' | while read A B C; do
    echo ""
    echo "# $B"
    echo "# -------------------------------------------"  
    if [ -f $A/CMakeClean.sh ]; then
        ./$A/CMakeClean.sh $* 
    else
        echo "> Nothing to clean ..."
    fi
done

echo ""
