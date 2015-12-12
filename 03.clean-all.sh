#!/bin/bash

MODE=$1
if [ -z "$MODE" ]; then
    MODE="quick"
fi

echo ""
echo "Clean mode: $MODE"

cat repositories | grep -v '^#' | while read A B C; do
    echo ""
    echo "# $B"
    echo "# -------------------------------------------"  
    if [ -f $A/CMakeClean.sh ]; then
        ./$A/CMakeClean.sh $MODE 
    else
        echo "> Nothing to clean ..."
    fi
done

echo ""
