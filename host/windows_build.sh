
cd build
cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc-7.3-posix -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++-posix -DCMAKE_FIND_ROOT_PATH=/usr/x86_64-w64-mingw32 -DCMAKE_LINKER=x86_64-w64-mingw32-ld  -DCROSSCOMPILE=1 ..
make
