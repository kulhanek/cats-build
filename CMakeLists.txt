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
SET(TRY_QT_LIB              ON  CACHE INTERNAL "QT is not neccessary" FORCE)
SET(PMFLIB_CATS_DRV         ON  CACHE INTERNAL "Should the driver for cats be built?" FORCE)
SET(PMFLIB_BUILD_UTILS      OFF CACHE INTERNAL "Should utilities be build?" FORCE)
SET(LIBS_COMPLEX            OFF CACHE INTERNAL "Support for complex numbers?" FORCE)

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

SET(QT_RPATH $ENV{QT_RPATH})

IF(QT_RPTATH)
    # the RPATH to be used when installing
    SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib:${CMAKE_INSTALL_PREFIX}/lib/drivers:${QT_RPATH}")
ELSE(QT_RPATH)
    # the RPATH to be used when installing
    SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib:${CMAKE_INSTALL_PREFIX}/lib/drivers")
ENDIF(QT_RPATH)

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

# ==============================================================================
# inter-project dependencies  -------------------------------------------------
# ==============================================================================
ADD_DEPENDENCIES(cscimafic_shared hipoly_shared)

ADD_DEPENDENCIES(cscimafic_shared hipoly_shared)
ADD_DEPENDENCIES(cprmfile_shared hipoly_shared)
ADD_DEPENDENCIES(netlib_shared hipoly_shared)
ADD_DEPENDENCIES(asl_shared hipoly_shared cscimafic_shared cnetcdf_shared)
ADD_DEPENDENCIES(fpmf_shared fprmfile_shared fscimafic_shared franlux_shared)
ADD_DEPENDENCIES(cpmf_shared hipoly_shared cscimafic_shared netlib_shared asl_shared)
ADD_DEPENDENCIES(cats_shared cats_drv_shared asl_shared netlib_shared cprmfile_shared cscimafic_shared)

# local blas and lapack
ADD_DEPENDENCIES(flapackd_shared fblasd_shared)
ADD_DEPENDENCIES(fpmf_shared fblasd_shared flapackd_shared)

