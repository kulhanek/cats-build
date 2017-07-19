# cats-build
Utilities for testing and building of the [CATs - Conversion and Analysis Tools](https://github.com/kulhanek/cats) package.

## CATs Features:
* processing data from simulations performed in the [AMBER](https://ambermd.org) package
* various CLI utilitis for manipulation with topology, coordinates, and trajectories
* scripting in the cats interpreter based on JavaScript

## Building and Installation

### Testing Mode
```bash
$ git clone --recursive https://github.com/kulhanek/cats-build.git
$ cd cats-build
$ ./build-utils/00.init-links.sh
$ ./01.pull-code.sh
$ ./04.build-inline.sh   # build the code inline in src/
```

### Production Build into the Infinity software repository
```bash
$ git clone --recursive https://github.com/kulhanek/cats-build.git
$ cd cats-build
$ ./build-utils/00.init-links.sh
$ ./01.pull-code.sh
$ ./10.build-final.sh
```

### Production Build into Custom Directory
```bash
$ git clone --recursive https://github.com/kulhanek/cats-build.git
$ cd cats-build
$ ./build-utils/00.init-links.sh
$ ./01.pull-code.sh
$ cmake -DCMAKE_INSTALL_PREFIX=/path/to/cats/installation/directory
$ make
$ make install
```

