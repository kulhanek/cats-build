#!/bin/bash

export DEVELOPMENT_ROOT=$PWD

if [ $# -ne 1 ]; then
   case $1 in
     "release") MODE="-DCMAKE_BUILD_TYPE=Release"
     ;;
     "debug") MODE="-DCMAKE_BUILD_TYPE=Debug"
     ;;
   esac
fi

# ------------------------------------------------------------------------------
function build_code() {
echo ""
echo "# $1 ($2)"
echo "# -------------------------------------------" 
OLDPWD=$PWD
mkdir -p $1 || exit 1
cd $1 || exit 1
if [ -f CMakeLists.txt ]; then
cmake $MODE . || exit 1
make || exit 1
fi
cd $OLDPWD
}
# ------------------------------------------------------------------------------

cat repositories | grep -v '^#' | while read A B C; do
   if [ -z "$2" ] || [ "$2" == "$B" ]; then 
      build_code $A $B || exit 1
   fi
done

