#=============#
# Build FFTW3 #
#=============#

set(FFTWVersion 3.3.8)

if(USE_FFTW)

  ExternalProject_Add(fftw3
      URL               http://www.fftw.org/fftw-${FFTWVersion}.tar.gz
      SOURCE_DIR        ${MODULE_BUILD_DIR}/fftw
      CONFIGURE_COMMAND ./configure
          CC=${CMAKE_C_COMPILER}
          CXX=${CMAKE_CXX_COMPILER}
          CPPFLAGS=${BigMac_CPPFLAGS}
          OPENMP_CFLAGS=${BigMac_OPENMP_CFLAGS}
          --prefix=${MODULE_BUILD_DIR}/fftw
          --enable-maintainer-mode
          --enable-shared
          --enable-sse2
          --enable-openmp
      BUILD_COMMAND     make
      INSTALL_COMMAND   make install
      BUILD_IN_SOURCE   1
      COMMAND           ./configure
          CC=${CMAKE_C_COMPILER}
          CXX=${CMAKE_CXX_COMPILER}
          CPPFLAGS=${BigMac_CPPFLAGS}
          OPENMP_CFLAGS=${BigMac_OPENMP_CFLAGS}
          --prefix=${MODULE_BUILD_DIR}/fftw
          --enable-maintainer-mode
          --enable-shared
          --enable-single
          --enable-sse2
          --enable-openmp
      COMMAND           make
      COMMAND           make install
  )

  set(FFTW_CXX_FLAGS "-DUSE_FFTW")
  set(FFTW_LD_FLAGS "-L ${MODULE_BUILD_DIR}/fftw/lib -lfftw3f_omp -lfftw3_omp \
-lfftw3f -lfftw3 -lm")

else(USE_FFTW)

  set(FFTW_CXX_FLAGS "")
  set(FFTW_LD_FLAGS "")

endif(USE_FFTW)

message(STATUS "FFTW3 Build: ${USE_FFTW}")
