#!/bin/bash

WINDOWS_MAJOR_VERSION=6
WINDOWS_MINOR_VERSION=1

CC="x86_64-w64-mingw32-gcc"

CCFLAGS=""
CCFLAGS+=" -Wno-sign-compare"
CCFLAGS+=" -fms-extensions"
CCFLAGS+=" -Wno-unknown-pragmas"

CPPDEFS=""
CPPDEFS+=" -D_WIN32"
CPPDEFS+=" -D_WIN64"

CPPPATH=""
CPPPATH+=" -I/usr/share/mingw-w64/include/ddk"

LINKFLAGS=""
LINKFLAGS+=" -shared"
LINKFLAGS+=" -nostdlib"
LINKFLAGS+=" -Wl,--exclude-all-symbols"
LINKFLAGS+=" -Wl,--entry,DriverEntry@8"
LINKFLAGS+=" -Wl,--subsystem,native"
LINKFLAGS+=" -Wl,--stack,0x40000"
LINKFLAGS+=" -Wl,--image-base=0x10000"
LINKFLAGS+=" -Wl,--major-os-version=${WINDOWS_MAJOR_VERSION}"
LINKFLAGS+=" -Wl,--minor-os-version=${WINDOWS_MINOR_VERSION}"
LINKFLAGS+=" -Wl,--major-image-version=${WINDOWS_MAJOR_VERSION}"
LINKFLAGS+=" -Wl,--minor-image-version=${WINDOWS_MINOR_VERSION}"
LINKFLAGS+=" -Wl,--major-subsystem-version=${WINDOWS_MAJOR_VERSION}"
LINKFLAGS+=" -Wl,--minor-subsystem-version=${WINDOWS_MINOR_VERSION}"

CCCOM="$CC $CCFLAGS $CPPDEFS $CPPPATH"
LINKCOM="$CC $LINKFLAGS"


set -e

echo "$CCCOM -c -o sampledrv.o sampledrv.c"
$CCCOM -c -o sampledrv.o sampledrv.c

echo "$LINKCOM -lntoskrnl -o sampledrv.sys sampledrv.o"
$LINKCOM -o sampledrv.sys sampledrv.o -lntoskrnl
