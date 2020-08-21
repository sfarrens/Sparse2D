#################
# Sparse2D 2017 #
#################

cmake_minimum_required(VERSION 3.0.0)
include(ExternalProject)
include(FindPkgConfig)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/modules/")

project(sparse2d)

# Load CMake function
include(functions)

# Set build type
if(CMAKE_BUILD_TYPE STREQUAL "")
  set(CMAKE_BUILD_TYPE "Release")
endif()
message(STATUS "CMake Build Type: ${CMAKE_BUILD_TYPE}")

# ----------------- #
# Find Dependencies #
# ----------------- #

# Locate OpenMP
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")
  find_package(BigMac 0.0.1 REQUIRED)
else()
  find_package(OpenMP REQUIRED)
endif()

# Locate CFITSIO
find_cfitsio()

# Set build location for external modules
set(MODULE_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/module_build/")

# Set compilation flags
set(CMAKE_CXX_FLAGS_RELEASE "-DNO_DISP_IO -g0 -O2 -fPIC \
    -fomit-frame-pointer ${OpenMP_CXX_FLAGS} -Wno-write-strings -DNDEBUG \
    ${BigMac_NOWARN}")
set(CMAKE_CXX_FLAGS_DEBUG "-DNO_DISP_IO -g -fPIC ${OpenMP_CXX_FLAGS} \
    -Wno-write-strings")

# ---- #
# FFTW #
# -----#

# Optional build of FFTW
option(USE_FFTW "Use FFTW for Fourier transformation" OFF)
include(BuildFFTW)

# ---- #
# NFFT #
# -----#

# Optional build of NFFT
option(BUILD_NFFT "Download and build NFFT" OFF)
include(BuildNFFT)

# ------------ #
# Sparse2D STD #
# -------------#

# Build standard Sparse2D libs
set(sparse2d_libs mga2d sparse3d sparse2d sparse1d tools)
foreach(library ${sparse2d_libs})
  build_lib(${library})
endforeach()

# Find all Sparse2D targets
find_targets(sparse2d_targets src cc)

# Build binaries
foreach(program ${sparse2d_targets})
  build_bin(${program} "${sparse2d_libs}" src cc)
endforeach(program)

# Install libraries
install(TARGETS ${sparse2d_libs} DESTINATION lib)

# Install binaraies
install(TARGETS ${sparse2d_targets} DESTINATION bin)

# ----- #
# MSVST #
# ------#

option(BUILD_MSVST "Build MSVST library" OFF)
message(STATUS "MSVST Build: ${BUILD_MSVST}")

if(BUILD_MSVST)

  # Build MSVST lib
  build_lib(msvst)
  set(msvst_libs msvst tools)

  # Find all MSVST targets
  find_targets(msvst_targets src/msvst cc)

  # Build binaries
  foreach(program ${msvst_targets})
    build_bin(${program} "${msvst_libs}" src/msvst cc)
  endforeach(program)

  # Install binaraies
  install(TARGETS ${msvst_targets} DESTINATION bin)

endif()

# ---------- #
# UNIT TESTS #
# -----------#

option(RUN_TESTS "Build and run unit tests" ON)
message(STATUS "Run Tests: ${RUN_TESTS}")

if(RUN_TESTS)

  # Add unit tests
  enable_testing()

  # Find all unit test targets
  find_targets(unit_tests tests cpp)

  # Build binaries
  foreach(program ${unit_tests})
    build_bin(${program} "${sparse2d_libs}" tests cpp)
    add_test(${program} ${program})
  endforeach(program)

endif()
