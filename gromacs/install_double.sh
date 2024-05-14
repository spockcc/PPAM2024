#!/bin/bash

spack load gcc@10.3.0

MAKE_THREADS=8

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

BUILD_DIR="$SCRIPT_DIR/build_double_gcc"
INSTALL_DIR="$SCRIPT_DIR/bin_double_gcc"

mkdir $BUILD_DIR
mkdir $INSTALL_DIR

# -DCMAKE_CXX_STANDARD_LIBRARIES="-lmtmetis" \
# -DCMAKE_C_STANDARD_LIRBARIES="-lmtmetis" \

pushd $BUILD_DIR
cmake ../gromacs-2021 \
-DCMAKE_C_COMPILER=gcc \
-DCMAKE_CXX_COMPILER=g++ \
-DGMX_BUILD_OWN_FFTW=on \
-DGMX_MPI=off \
-DGMX_DOUBLE=on \
-DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
-DCMAKE_BUILD_TYPE=Release \
-DREGRESSIONTEST_DOWNLOAD=off \
-DBUILD_TESTING=off \
-DGMX_GPU=off \
-DGMX_OPENMP=on \
-DGMX_X11=off \
-DGMXAPI=off

make -j$MAKE_THREADS
make install

popd