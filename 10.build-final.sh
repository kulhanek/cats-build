#!/bin/bash

PREFIX="lcc"
LOG="$PWD/single.log"

set -o pipefail

# ------------------------------------------------------------------------------

if [ -z "$AMS_ROOT_V9" ]; then
   echo "ERROR: This installation script works only in the Infinity environment!"
   exit 1
fi

module add qt:5.9.6

# ------------------------------------

# determine number of available CPUs if not specified
if [ -z "$N" ]; then
    N=1
    type nproc &> /dev/null
    if type nproc &> /dev/null; then
        N=`nproc --all`
    fi
    if [ "$N" -gt 8 ]; then
        N=8
    fi
fi

# ------------------------------------------------------------------------------
# run pre-installation hook if available
if [ -f ./preinstall-hook ]; then
    source ./preinstall-hook || exit 1
fi

# names ------------------------------
NAME="cats"
ARCH="m64-ub8"
MODE="single"
echo ""
echo "Build: $NAME:$VERS:$ARCH:$MODE"
echo ""

# build and install software ---------
cmake -DCMAKE_INSTALL_PREFIX="$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE" . | tee $LOG
make -j "$N" install | tee -a $LOG
if [ $? -ne 0 ]; then exit 1; fi

# prepare build file -----------------
SOFTBLDS="$SOFTREPO/$PREFIX/_ams_bundle/blds/"
cd $SOFTBLDS || exit 1
VERIDX=`ams-bundle newverindex $NAME:$VERS:$ARCH:$MODE`

cat > $NAME:$VERS:$ARCH:$MODE.bld << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Advanced Module System (AMS) build file -->
<build name="$NAME" ver="$VERS" arch="$ARCH" mode="$MODE" verindx="$VERIDX">
    <setup>
        <variable name="AMS_PACKAGE_DIR" value="$PREFIX/$NAME/$VERS/$ARCH/$MODE" operation="set" priority="modaction"/>
        <variable name="PATH" value="\$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE/bin" operation="prepend"/>
    </setup>
    <deps>
        <dep name="libfftw3-dev"            type="deb"/>
        <dep name="libreadline7"            type="deb"/>
        <dep name="qt:5.9.6"                type="sync"/>
        <dep name="intelcore:2019.3.199"    type="sync"/>
    </deps>
</build>
EOF
if [ $? -ne 0 ]; then exit 1; fi

echo ""
echo "Rebuilding bundle ..."
ams-bundle rebuild | tee -a $LOG
if [ $? -ne 0 ]; then exit 1; fi

echo "LOG: $LOG"
echo ""
