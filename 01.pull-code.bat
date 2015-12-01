#!/bin/bash

@echo off
setlocal ENABLEDELAYEDEXPANSION

for /f "tokens=*" %%L in (repositories) do (

   for /f "tokens=1" %%S in ("%%L") do set A=%%S
   for /f "tokens=2" %%T in ("%%L") do set B=%%T

   echo !A!
)

endlocal


# ------------------------------------------------------------------------------
function dowload_code() {
echo ""
echo "# $2 -> $1"
echo "# -------------------------------------------" 
OLDPWD=$PWD
mkdir -p $1 || exit 1
cd $1 || exit 1
if ! [ -d .git ]; then
   git init
   git remote add github https://github.com/kulhanek/${2}.git
fi 
git pull github master
cd $OLDPWD
}

# ------------------------------------------------------------------------------

cat repositories | grep -v '^#' | while read A B; do
   dowload_code $A $B || exit 1
done

