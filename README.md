# cats-build
Utilities for testing and buliding of the [CATs - Conversion and Analysis Tools](https://github.com/kulhanek/cats) package. 

## CATs Features:
* processing data from simulations performed in the [AMBER](https://ambermd.org) package
* various CLI utilitis for manipulation with topology, coordinates, and trajectories
* scripting in the cats interpreter based on JavaScript

## Testing Mode
The typical procedure is:
```bash
$ ./01.pull-code.sh      # update the code
$ ./04.build-inline.sh   # build the code inline in src/
```
## Production Build into the Infinity software repository
The typical procedure is:
```bash
$ ./01.pull-code.sh      # update the code
$ ./10.build-final.sh    # final build
```

## Production Build into Custom Directory
The typical procedure is:
```bash
$ ./01.pull-code.sh      # update the code
$ cmake -DCMAKE_INSTALL_PREFIX=/path/to/cats/installation/direrctory
$ make
$ make install
```

