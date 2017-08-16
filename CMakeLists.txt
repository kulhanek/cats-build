# ==============================================================================
# CATs - Conversion and Analysis Tools
# ==============================================================================

CMAKE_MINIMUM_REQUIRED(VERSION 2.8 FATAL_ERROR)
#SET(CMAKE_VERBOSE_MAKEFILE ON)

# ==============================================================================
# conditional setup ------------------------------------------------------------
# ==============================================================================

# target architecture: allowed values are: em64t
SET(TARGET_ARCHITECTURE em64t)

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
SET(PMFLIB_SANDER_DRV       OFF CACHE BOOL "Should the driver for sander be built?" FORCE)
SET(PMFLIB_PMEMD_DRV        OFF CACHE BOOL "Should the driver for pmemd be built?" FORCE)
SET(PMFLIB_CPMD_DRV         OFF CACHE BOOL "Should the driver for cpmd be built?" FORCE)
SET(PMFLIB_CP2K_DRV         OFF CACHE BOOL "Should the driver for cp2k be built?" FORCE)
SET(PMFLIB_XDYNBP_DRV       OFF CACHE BOOL "Should the driver for xdynbp be built?" FORCE)
SET(PMFLIB_LIBATOMS_DRV     OFF CACHE BOOL "Should the driver for libatoms be built?" FORCE)
SET(PMFLIB_BUILD_UTILS      OFF CACHE BOOL "Should utilities be build?" FORCE)
SET(LIBS_COMPLEX            OFF CACHE BOOL "Support for complex numbers?" FORCE)

# ==============================================================================
# libraries --------------------------------------------------------------------
# ==============================================================================

# try to find math kernel library
SET(MKL_HOME "$ENV{MKL_HOME}")

IF(MKL_HOME)
    SET(MKL_FOUND TRUE)
    IF(TARGET_ARCHITECTURE STREQUAL i686)
        # NOT SUPPORTED
        SET(MKL_LIBS mkl_intel mkl_sequential mkl_core pthread)
    ELSEIF(TARGET_ARCHITECTURE STREQUAL em64t)
        LINK_DIRECTORIES(${MKL_HOME}/lib/intel64)
        SET(MKL_LIBS mkl_intel_lp64 mkl_sequential mkl_core pthread)
    ELSE(TARGET_ARCHITECTURE STREQUAL i686)
        MESSAGE(FATAL_ERROR "ERROR: Unsupported target architecture: ${TARGET_ARCHITECTURE}")
    ENDIF(TARGET_ARCHITECTURE STREQUAL i686)
ENDIF(MKL_HOME)

LINK_DIRECTORIES(${CMAKE_BINARY_DIR}/lib)
LINK_DIRECTORIES(${CMAKE_BINARY_DIR}/lib/drivers)

# ==============================================================================
# rpaths -----------------------------------------------------------------------
# ==============================================================================

# intel core and QT libraries
SET(INTEL_CORE_HOME "$ENV{INTEL_CORE_HOME}")
SET(QT_RPATH "$ENV{QT_RPATH}")

# use, i.e. don't skip the full RPATH for the build tree
SET(CMAKE_SKIP_BUILD_RPATH  FALSE)

# when building, don't use the install RPATH already
# (but later on when installing)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE) 

# the RPATH to be used when installing
SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib:${CMAKE_INSTALL_PREFIX}/lib/drivers")

IF(QT_RPATH)
    MESSAGE("-- QT_RPATH: ${QT_RPATH}")
    SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_RPATH}:${QT_RPATH}")
ENDIF(QT_RPATH)

IF(INTEL_CORE_HOME)
    MESSAGE("-- INTEL_CORE_HOME: ${INTEL_CORE_HOME}")
    SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_RPATH}:${INTEL_CORE_HOME}")
ENDIF(INTEL_CORE_HOME)

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
IF(NOT MKL_FOUND)
    ADD_SUBDIRECTORY(src/thirdparty/blas/netlib)
    ADD_SUBDIRECTORY(src/thirdparty/lapack/3.1.1)
ENDIF(NOT MKL_FOUND)
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
ADD_DEPENDENCIES(cscimafic_shared hipoly_shared flapackd_shared)
ADD_DEPENDENCIES(cprmfile_shared hipoly_shared)
ADD_DEPENDENCIES(netlib_shared hipoly_shared)
ADD_DEPENDENCIES(asl_shared hipoly_shared cscimafic_shared cnetcdf_shared)
ADD_DEPENDENCIES(fpmf_shared fprmfile_shared fscimafic_shared franlux_shared)
ADD_DEPENDENCIES(cpmf_shared hipoly_shared cscimafic_shared netlib_shared asl_shared)
ADD_DEPENDENCIES(cats_shared cats_drv_shared asl_shared netlib_shared cprmfile_shared cscimafic_shared)

IF(NOT MKL_FOUND)
    # local blas and lapack
    ADD_DEPENDENCIES(flapackd_shared fblasd_shared)
    ADD_DEPENDENCIES(cscimafic_shared flapackd_shared)
    ADD_DEPENDENCIES(fscimafic_shared flapackd_shared)
    ADD_DEPENDENCIES(fpmf_shared fblasd_shared flapackd_shared)
ENDIF(NOT MKL_FOUND)

