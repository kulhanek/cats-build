#!/bin/bash

echo ""
if [ -z "$*" ]; then
    echo "Clean mode: simple"
else
    echo "Clean mode: $*"
fi

cat repositories | grep -v '^#' | while read A B; do
    if [ -f $A/CMakeClean ]; then
        echo ""
        echo "# $B"
        echo "# -------------------------------------------"  
        ./$A/CMakeClean $* 
    fi
done

echo ""
