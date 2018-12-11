#!/bin/bash

# Windows 7
WINDOWS_MAJOR_VERSION=6
WINDOWS_MINOR_VERSION=1


CC="x86_64-w64-mingw32-gcc"

CCFLAGS=""
CCFLAGS+=" -Wno-sign-compare"
CCFLAGS+=" -fms-extensions"
CCFLAGS+=" -Wno-unknown-pragmas"

WINNT_VERSION=$(printf 0x%04X $(((WINDOWS_MAJOR_VERSION << 8) | WINDOWS_MINOR_VERSION)))

CPPDEFS=""
CPPDEFS+=" -D_WIN32"
CPPDEFS+=" -D_WIN64"

##
# Bug 2: Setting this to >= 6.1 and including ntifs.h causes this error:
#
# In file included from sampledrv.c:5:0:
# /usr/share/mingw-w64/include/ddk/ntifs.h:4256:47: error: flexible array member in union
#      STORAGE_QUERY_DEPENDENT_VOLUME_LEV1_ENTRY Lev1Depends[];
#                                                ^~~~~~~~~~~
# /usr/share/mingw-w64/include/ddk/ntifs.h:4257:47: error: flexible array member in union
#      STORAGE_QUERY_DEPENDENT_VOLUME_LEV2_ENTRY Lev2Depends[];
#                                                ^~~~~~~~~~~
##
#CPPDEFS+=" -D_WIN32_WINNT=${WINNT_VERSION}"

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
