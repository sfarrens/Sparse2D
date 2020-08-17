#! /bin/bash
dest_dir=`pwd`
touch ChangeLog
rm -rf autom4te.cache
autoreconf --verbose --install --symlink --force
autoreconf --verbose --install --symlink --force
autoreconf --verbose --install --symlink --force
echo "FFTW_CXX_FLAGS = ${1}"
echo "FFTW_OMP_FLAGS = ${2}"
rm -f config.cache
CPPFLAGS=${1} OPENMP_CFLAGS=${2} ./configure --prefix=$dest_dir --enable-maintainer-mode --enable-shared --enable-sse2 --enable-openmp
make
make install
CPPFLAGS=${1} OPENMP_CFLAGS=${2} ./configure --prefix=$dest_dir --enable-maintainer-mode --enable-shared --enable-single --enable-sse2 --enable-openmp
make
make install
make distclean
