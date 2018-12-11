#!/bin/bash

SITES="clusters"
PREFIX="common"

if [[ ! ( ( "`hostname -f`" == "deb8.ncbr.muni.cz" ) || ( "`hostname -f`" == *"salomon"* ) )  ]]; then
    echo "unsupported build machine!"
    exit 1
fi

# ------------------------------------------------------------------------------

if [ -z "$AMS_ROOT" ]; then
   echo "ERROR: This installation script works only in the Infinity environment!"
   exit 1
fi

# add cmake from modules if they exist
if ! type module &> /dev/null; then
    echo "command 'module' required!"
    exit 1
fi

module add cmake git
module add qt:5.9.6

# required in IT4I
module add intelcdk
module add readline  # this also includes ncurses

# ------------------------------------

# determine number of available CPUs if not specified
if [ -z "$N" ]; then
    N=1
    type nproc &> /dev/null
    if type nproc &> /dev/null; then
        N=`nproc --all`
    fi
    if [ "$N" -gt 4 ]; then
        N=4
    fi
fi

# ------------------------------------------------------------------------------
# run pre-installation hook if available
if [ -f ./preinstall-hook ]; then
    source ./preinstall-hook || exit 1
fi

# names ------------------------------
NAME="cats"
ARCH=`uname -m`
MODE="single"
echo ""
echo "Build: $NAME:$VERS:$ARCH:$MODE"
echo ""

# build and install software ---------
cmake -DCMAKE_INSTALL_PREFIX="$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE" .
make -j "$N" install
if [ $? -ne 0 ]; then exit 1; fi

# prepare build file -----------------
SOFTBLDS="$AMS_ROOT/etc/map/builds/$PREFIX"
VERIDX=`ams-map-manip newverindex $NAME:$VERS:$ARCH:$MODE`

cat > $SOFTBLDS/$NAME:$VERS:$ARCH:$MODE.bld << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Advanced Module System (AMS) build file -->
<build name="$NAME" ver="$VERS" arch="$ARCH" mode="$MODE" verindx="$VERIDX">
    <setup>
        <variable name="AMS_PACKAGE_DIR" value="$PREFIX/$NAME/$VERS/$ARCH/$MODE" operation="set" priority="modaction"/>
        <variable name="PATH" value="\$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE/bin" operation="prepend"/>
    </setup>
    <deps>
        <dep name="libfftw3-dev"            type="deb"/>
        <dep name="libreadline6"            type="deb"/>
        <dep name="libgfortran3"            type="deb"/>
        <dep name="qt:5.9.6"                type="sync"/>
        <dep name="intelcore:2017.1.132"    type="sync"/>
    </deps>
</build>
EOF
if [ $? -ne 0 ]; then exit 1; fi

echo ""
echo "Adding builds ..."
ams-map-manip addbuilds $SITES $NAME:$VERS:$ARCH:$MODE >> ams.log 2>&1
if [ $? -ne 0 ]; then echo ">>> ERROR: see ams.log"; exit 1; fi

echo "Distribute builds ..."
ams-map-manip distribute >> ams.log 2>&1
if [ $? -ne 0 ]; then echo ">>> ERROR: see ams.log"; exit 1; fi

echo "Rebuilding cache ..."
ams-cache rebuildall >> ams.log 2>&1
if [ $? -ne 0 ]; then echo ">>> ERROR: see ams.log"; exit 1; fi

echo "Log file: ams.log"
echo ""

