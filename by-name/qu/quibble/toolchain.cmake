# Upstream's mingw-amd64.cmake, with the UEFI freestanding link flags added.
# The image must not import msvcrt/kernel32, and the compiler ABI probes are
# skipped because they link against a CRT that a freestanding image cannot use.
SET(CMAKE_SYSTEM_NAME Windows)

SET(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)
SET(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)
SET(CMAKE_RC_COMPILER x86_64-w64-mingw32-windres)
SET(CMAKE_SYSTEM_PROCESSOR "AMD64")

set(CMAKE_EXE_LINKER_FLAGS "-static -nostdlib -nodefaultlibs -Wl,--disable-runtime-pseudo-reloc")

set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

SET(CMAKE_FIND_ROOT_PATH /usr/x86_64-w64-mingw32)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
