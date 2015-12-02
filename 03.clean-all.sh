#!/bin/bash

echo ""
if [ -z "$*" ]; then
    echo "Clean mode: simple"
else
    echo "Clean mode: $*"
fi

echo ""
echo "# $B"
echo "# -------------------------------------------"  
cat repositories | grep -v '^#' | while read A B; do
    if [ -f $A/CMakeClean.sh ]; then
        ./$A/CMakeClean.sh $* 
    else
        echo "> Nothing to clean ..."
    fir
done

echo ""
