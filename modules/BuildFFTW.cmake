#=============#
# Build FFTW  #
#=============#

# Set FFTW Version
set(FFTWVersion 3.3.8)
set(FFTWHash 8aac833c943d8e90d51b697b27d4384d)

if(USE_FFTW)

  # Set C/C++ compiler and flags
  set(FFTW_COMPILE
      CC=${CMAKE_C_COMPILER}
      CXX=${CMAKE_CXX_COMPILER}
      ${BigMac_FFTW})

  # Set FFTW configuration flags
  set(FFTW_CONFIG_FLAGS
      --prefix=${MODULE_BUILD_DIR}
      --enable-maintainer-mode
      --enable-shared
      --enable-threads
      --enable-sse2
      --enable-openmp)

  # Download and build FFTW
  ExternalProject_Add(fftw
      URL               http://www.fftw.org/fftw-${FFTWVersion}.tar.gz
      URL_HASH          MD5=${FFTWHash}
      SOURCE_DIR        ${MODULE_BUILD_DIR}fftw
      BUILD_IN_SOURCE   1
      CONFIGURE_COMMAND ./configure ${FFTW_COMPILE} ${FFTW_CONFIG_FLAGS}
      COMMAND           make && make install
      COMMAND           ./configure ${FFTW_COMPILE} ${FFTW_CONFIG_FLAGS} --enable-single
      COMMAND           make && make install
      COMMAND           make clean
  )

  # Set FFTW flags for CMake project
  set(FFTW_LD_FLAGS "-L ${MODULE_BUILD_DIR}/lib -lfftw3f_omp -lfftw3_omp \
      -lfftw3f -lfftw3 -lm")

else(USE_FFTW)

  set(FFTW_LD_FLAGS "")

endif(USE_FFTW)

message(STATUS "FFTW Build: ${USE_FFTW}")
