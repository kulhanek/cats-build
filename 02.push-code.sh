#!/bin/bash

# ------------------------------------------------------------------------------
function push_code() {
echo ""
echo "# $2 -> $1"
echo "# -------------------------------------------" 
OLDPWD=$PWD
cd $1 || exit 1
git push github master
cd $OLDPWD
}

# ------------------------------------------------------------------------------

if [ -f repositories.writable ]; then
    cat repositories.writable | grep -v '^#' | while read A B; do
    push_code $A $B || exit 1
    done
else
    cat repositories | grep -v '^#' | while read A B; do
    push_code $A $B || exit 1
    done
fi
