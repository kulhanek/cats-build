# ==============================================================================
# CATs - Conversion and Analysis Tools
# ==============================================================================

CMAKE_MINIMUM_REQUIRED(VERSION 2.8 FATAL_ERROR)
#SET(CMAKE_VERBOSE_MAKEFILE ON)

# ==============================================================================
# project setup ----------------------------------------------------------------
# ==============================================================================

# what languages we use ---------------------------
ENABLE_LANGUAGE(C)
ENABLE_LANGUAGE(CXX)
ENABLE_LANGUAGE(Fortran)

# this is composite project ----------------------
SET(COMPOSITE_PROJECT TRUE)
SET(DEVELOPMENT_ROOT "${CMAKE_BINARY_DIR}/src")

# extra options ----------------------------------
SET(TRY_QT_LIB              ON  CACHE BOOL "QT is not neccessary" FORCE)
SET(PMFLIB_CATS_DRV         ON  CACHE BOOL "Should the driver for cats be built?" FORCE)
SET(PMFLIB_SKIP_BIN_UTILS   ON  CACHE BOOL "Should utilities be skip in bin?" FORCE)

# ==============================================================================
# libraries --------------------------------------------------------------------
# ==============================================================================

LINK_DIRECTORIES(${CMAKE_BINARY_DIR}/lib)
LINK_DIRECTORIES(${CMAKE_BINARY_DIR}/lib/drivers)

# ==============================================================================
# rpaths -----------------------------------------------------------------------
# ==============================================================================

# use, i.e. don't skip the full RPATH for the build tree
SET(CMAKE_SKIP_BUILD_RPATH  FALSE)

# when building, don't use the install RPATH already
# (but later on when installing)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE) 

# the RPATH to be used when installing
SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")

# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)

# ==============================================================================
# compiler setups --------------------------------------------------------------
# ==============================================================================

# C options
SET(CMAKE_C_FLAGS_RELEASE "-O2 -m64")
SET(CMAKE_C_FLAGS_DEBUG "-g -m64 -Wall -Werror -pedantic-errors -Wundef -Wno-long-long")

# C++ options
SET(CMAKE_CXX_FLAGS_RELEASE "-O2 -m64")
SET(CMAKE_CXX_FLAGS_DEBUG "-O0 -m64 -g -Wall -Werror -pedantic-errors -Wundef -Wno-long-long")

SET(CMAKE_BUILD_TYPE Release)
#SET(CMAKE_BUILD_TYPE Debug)

# ==============================================================================
# project subdirectories  ------------------------------------------------------
# ==============================================================================

# thirdparty ---------------------------------------
ADD_SUBDIRECTORY(src/thirdparty/blas/netlib)
ADD_SUBDIRECTORY(src/thirdparty/lapack/3.1.1)
ADD_SUBDIRECTORY(src/thirdparty/csparse/2.2.1)
ADD_SUBDIRECTORY(src/thirdparty/ranlux/1.0)
ADD_SUBDIRECTORY(src/thirdparty/netcdfcore/4.0.1)

# projects ---------------------------------------
ADD_SUBDIRECTORY(src/projects/hipoly/1.0)
ADD_SUBDIRECTORY(src/projects/scimafic/1.0)
ADD_SUBDIRECTORY(src/projects/prmfile/1.0)
ADD_SUBDIRECTORY(src/projects/netlib/1.0)
ADD_SUBDIRECTORY(src/projects/pmflib/5.0)
ADD_SUBDIRECTORY(src/projects/asl/2.0)
ADD_SUBDIRECTORY(src/projects/cats/2.0)

