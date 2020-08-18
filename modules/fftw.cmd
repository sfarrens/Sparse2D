#! /bin/bash
dest_dir=`pwd`
touch ChangeLog
rm -rf autom4te.cache
autoreconf --verbose --install --symlink --force
autoreconf --verbose --install --symlink --force
autoreconf --verbose --install --symlink --force
rm -f config.cache
CC=${1} CXX=${2} CPPFLAGS=${3} OPENMP_CFLAGS=${4} ./configure --prefix=$dest_dir --enable-maintainer-mode --enable-shared --enable-sse2 --enable-openmp
make
make install
CC=${1} CXX=${2} CPPFLAGS=${3} OPENMP_CFLAGS=${4} ./configure --prefix=$dest_dir --enable-maintainer-mode --enable-shared --enable-single --enable-sse2 --enable-openmp
make
make install
make distclean
