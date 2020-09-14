#============#
# Build nFFT #
#============#

# Set NFFT Version
set(NFFTVersion 3.5.1)
set(NFFTHash 8d53164d7cd85ad77e1bd03e36c4a99ef73c77f640e527db816cdc3fcb43d6aa)

if(BUILD_NFFT)

  # Set C/C++ compiler and flags
  set(NFFT_COMPILE
      CC=${CMAKE_C_COMPILER}
      CXX=${CMAKE_CXX_COMPILER}
      ${BigMac_NFFT})

  # Set NFFT configuration flags
  set(NFFT_CONFIG_FLAGS
      --prefix=${MODULE_BUILD_DIR}
      --with-fftw3=${MODULE_BUILD_DIR}
      --enable-openmp)

  # Download and build NFFT
  ExternalProject_Add(nfft
    URL               https://github.com/NFFT/nfft/archive/${NFFTVersion}.tar.gz
    URL_HASH          SHA256=${NFFTHash}
    SOURCE_DIR        ${MODULE_BUILD_DIR}nfft
    BUILD_IN_SOURCE   1
    CONFIGURE_COMMAND ./bootstrap.sh &&
                      ./configure ${NFFT_COMPILE} ${NFFT_CONFIG_FLAGS}
    BUILD_COMMAND     export LD_LIBRARY_PATH=${MODULE_BUILD_DIR}lib && make -j8
    INSTALL_COMMAND   make install
  )

endif(BUILD_NFFT)

message(STATUS "nFFT Build: ${BUILD_NFFT}")
