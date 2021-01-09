
# Copyright (c) 2021 embed-dsp
# All Rights Reserved

# $Author:   Gudmundur Bogason <gb@embed-dsp.com> $
# $Date:     $
# $Revision: $


# Package.
PACKAGE_NAME = avr-gcc

# ...
BINUTILS_NAME = binutils-2.35.1
GCC_NAME = gcc-10.2.0
GDB_NAME = gdb-10.1
LIBC_NAME = avr-libc3
LIBC_COMMIT = d09c2a61764aced3274b6dde4399e11b0aee4a87

# Set number of simultaneous compile jobs.
J = 16

# System and Machine.
SYSTEM = $(shell ./bin/get_system.sh)
MACHINE = $(shell ./bin/get_machine.sh)

# System configuration.
GDB_CONFIGURE_FLAGS =

# Compiler.
CFLAGS = -Wall -O2
CXXFLAGS = -Wall -O2

# Linux system.
ifeq ($(SYSTEM),linux)
	# System configuration.
	# Compiler.
	CC = /usr/bin/gcc
	CXX = /usr/bin/g++
	# Installation directory.
	INSTALL_DIR = /opt
endif

# Cygwin system.
ifeq ($(SYSTEM),cygwin)
	# System configuration.
	GDB_CONFIGURE_FLAGS += --disable-source-highlight
	# Compiler.
	CC = /usr/bin/gcc
	CXX = /usr/bin/g++
	# Installation directory.
	INSTALL_DIR = /cygdrive/c/opt
endif

# MSYS2/mingw32 system.
ifeq ($(SYSTEM),mingw32)
	# System configuration.
	# Compiler.
	CC = /mingw32/bin/gcc
	CXX = /mingw32/bin/g++
	# Installation directory.
	INSTALL_DIR = /c/opt
endif

# MSYS2/mingw64 system.
ifeq ($(SYSTEM),mingw64)
	# System configuration.
	GDB_CONFIGURE_FLAGS += --disable-source-highlight
	# Compiler.
	CC = /mingw64/bin/gcc
	CXX = /mingw64/bin/g++
	# Installation directory.
	INSTALL_DIR = /c/opt
endif

# Installation directory.
PREFIX = $(INSTALL_DIR)/$(PACKAGE_NAME)

# ...
BUILD_DIR = $(shell pwd)/build

XXX = avr-$(GCC_NAME)-$(MACHINE)-$(SYSTEM)

BUILD_PREFIX = $(BUILD_DIR)/$(XXX)
BUILD_PREFIX_LIBC = $(BUILD_DIR)/$(LIBC_NAME)-$(MACHINE)-$(SYSTEM)

# ...
PATH := $(BUILD_PREFIX)/bin:$(PATH)
export PATH


all:
	@echo "PREFIX = $(PREFIX)"
	@echo "BUILD_PREFIX = $(BUILD_PREFIX)"
	@echo "BUILD_PREFIX_LIBC = $(BUILD_PREFIX_LIBC)"
	@echo ""
	@echo "## Get Source Code"
	@echo "make download"
	@echo ""
	@echo "## Build"
	@echo "make build"
	@echo ""
	@echo "## Install"
	@echo "make install"
	@echo ""
	@echo "## Create Distribution"
	@echo "make dist"
	@echo ""
	@echo "## Cleanup"
	@echo "make clean"
	@echo ""
	


.PHONY: download
download:
	-mkdir src
	cd src && wget https://ftp.gnu.org/gnu/binutils/$(BINUTILS_NAME).tar.xz
	cd src && wget https://ftp.gnu.org/gnu/gcc/$(GCC_NAME)/$(GCC_NAME).tar.xz
	cd src && wget https://ftp.gnu.org/gnu/gdb/$(GDB_NAME).tar.xz
	cd src && git clone https://github.com/stevenj/$(LIBC_NAME).git $(LIBC_NAME)



.PHONY: build
build: build-binutils build-gcc build-gdb build-libc



.PHONY: dist
dist:
	cd build && tar Jcf $(XXX).tar.xz $(XXX)



.PHONY: install
install:
	-mkdir -p $(PREFIX)
	cp -a $(BUILD_PREFIX) $(PREFIX)



.PHONY: clean
clean:
	-rm -rf build
	


# --------------------
# binutils
# --------------------

.PHONY: build-binutils
build-binutils: prepare-binutils configure-binutils compile-binutils install-binutils


.PHONY: prepare-binutils
prepare-binutils:
	-mkdir build
	cd build && tar xf ../src/$(BINUTILS_NAME).tar.xz


.PHONY: configure-binutils
configure-binutils:
	-mkdir -p build/$(BINUTILS_NAME)-obj
	cd build/$(BINUTILS_NAME)-obj && ../$(BINUTILS_NAME)/configure CC=$(CC) CFLAGS="$(CFLAGS)" CXX=$(CXX) CXXFLAGS="$(CXXFLAGS)" --prefix=$(BUILD_PREFIX) --target=avr --disable-nls --disable-werror


.PHONY: compile-binutils
compile-binutils:
	cd build/$(BINUTILS_NAME)-obj && make -j$(J)


.PHONY: install-binutils
install-binutils:
	cd build/$(BINUTILS_NAME)-obj && make install-strip

# --------------------
# gcc
# --------------------

.PHONY: build-gcc
build-gcc: prepare-gcc configure-gcc compile-gcc install-gcc


.PHONY: prepare-gcc
prepare-gcc:
	-mkdir build
	cd build && tar xf ../src/$(GCC_NAME).tar.xz
	cd build/$(GCC_NAME) && ./contrib/download_prerequisites


.PHONY: configure-gcc
configure-gcc:
	-mkdir -p build/$(GCC_NAME)-obj
	cd build/$(GCC_NAME)-obj && ../$(GCC_NAME)/configure CC=$(CC) CFLAGS="$(CFLAGS)" CXX=$(CXX) CXXFLAGS="$(CXXFLAGS)" --prefix=$(BUILD_PREFIX) --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --disable-libada --with-dwarf2 --disable-shared --enable-static --enable-mingw-wildcard --enable-plugin --with-gnu-as


.PHONY: compile-gcc
compile-gcc:
	cd build/$(GCC_NAME)-obj && make -j$(J)


.PHONY: install-gcc
install-gcc:
	cd build/$(GCC_NAME)-obj && make install-strip

# --------------------
# gdb
# --------------------

.PHONY: build-gdb
build-gdb: prepare-gdb configure-gdb compile-gdb install-gdb


.PHONY: prepare-gdb
prepare-gdb:
	-mkdir build
	cd build && tar xf ../src/$(GDB_NAME).tar.xz


.PHONY: configure-gdb
configure-gdb:
	-mkdir -p build/$(GDB_NAME)-obj
	cd build/$(GDB_NAME)-obj && ../$(GDB_NAME)/configure CC=$(CC) CFLAGS="$(CFLAGS)" CXX=$(CXX) CXXFLAGS="$(CXXFLAGS)" --prefix=$(BUILD_PREFIX) --target=avr --with-static-standard-libraries $(GDB_CONFIGURE_FLAGS)


.PHONY: compile-gdb
compile-gdb:
	cd build/$(GDB_NAME)-obj && make -j$(J)


.PHONY: install-gdb
install-gdb:
	strip build/$(GDB_NAME)-obj/gdb/gdb
	cd build/$(GDB_NAME)-obj && make install

# --------------------
# libc
# --------------------

.PHONY: build-libc
build-libc: prepare-libc configure-libc compile-libc install-libc


.PHONY: prepare-libc
prepare-libc:
	-mkdir build
	cd build && cp -a ../src/$(LIBC_NAME) .
	cd build/$(LIBC_NAME) && git checkout $(LIBC_COMMIT)
	cd build/$(LIBC_NAME) && ./bootstrap


.PHONY: configure-libc
configure-libc:
	-mkdir -p build/$(LIBC_NAME)-obj
	cd build/$(LIBC_NAME)-obj && ../$(LIBC_NAME)/configure --prefix=$(BUILD_PREFIX_LIBC) --host=avr --build=`../$(LIBC_NAME)/config.guess`


.PHONY: compile-libc
compile-libc:
	cd build/$(LIBC_NAME)-obj && make -j$(J)


.PHONY: install-libc
install-libc:
	cd build/$(LIBC_NAME)-obj && make install-strip
	cp -a $(BUILD_PREFIX_LIBC)/avr/* $(BUILD_PREFIX)/avr
	cp -a $(BUILD_PREFIX_LIBC)/bin/* $(BUILD_PREFIX)/bin
	cp -a $(BUILD_PREFIX_LIBC)/share/* $(BUILD_PREFIX)/share


# NOTES: mingw64
#  CXXLD  gdb.exe
#C:/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/10.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: C:/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/10.2.0/../../../../lib/libncursesw.a(lib_termcap.o):(.bss+0x8): multiple definition of `UP'; ../readline/readline/libreadline.a(terminal.o):terminal.c:(.bss+0x98): first defined here
#C:/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/10.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: C:/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/10.2.0/../../../../lib/libncursesw.a(lib_termcap.o):(.bss+0x0): multiple definition of `BC'; ../readline/readline/libreadline.a(terminal.o):terminal.c:(.bss+0xa0): first defined here
#C:/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/10.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: C:/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/10.2.0/../../../../lib/libncursesw.a(lib_tputs.o):(.bss+0x6): multiple definition of `PC'; ../readline/readline/libreadline.a(terminal.o):terminal.c:(.bss+0xa8): first defined here
#C:/msys64/mingw64/bin/../lib/gcc/x86_64-w64-mingw32/10.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: ../gnulib/import/libgnu.a(getrandom.o):getrandom.c:(.text+0x21): undefined reference to `BCryptGenRandom'
#collect2.exe: error: ld returned 1 exit status
#make[3]: *** [Makefile:1866: gdb.exe] Error 1
#make[3]: Leaving directory '/c/Users/gb/workspaces/wrk_avr/ed_avr_gcc/build/gdb-10.1-obj/gdb'
#make[2]: *** [Makefile:10078: all-gdb] Error 2
#make[2]: Leaving directory '/c/Users/gb/workspaces/wrk_avr/ed_avr_gcc/build/gdb-10.1-obj'
#make[1]: *** [Makefile:866: all] Error 2
#make[1]: Leaving directory '/c/Users/gb/workspaces/wrk_avr/ed_avr_gcc/build/gdb-10.1-obj'
#make: *** [Makefile:230: compile-gdb] Error 2

# NOTES: cygwin64
# GDB
#  CXXLD  gdb.exe
#cp-support.o:cp-support.c:(.text+0x1ec2): relocation truncated to fit: R_X86_64_PC32 against undefined symbol `TLS init function for thread_local_segv_handler'
#cp-support.o:cp-support.c:(.text+0x1edb): relocation truncated to fit: R_X86_64_PC32 against undefined symbol `TLS init function for thread_local_segv_handler'
#collect2: error: ld returned 1 exit status
#make[3]: *** [Makefile:1866: gdb.exe] Error 1
#make[3]: Leaving directory '/cygdrive/c/Users/gb/workspaces/wrk_avr/ed_avr_gcc/build/gdb-10.1-obj/gdb'
#make[2]: *** [Makefile:10069: all-gdb] Error 2
#make[2]: Leaving directory '/cygdrive/c/Users/gb/workspaces/wrk_avr/ed_avr_gcc/build/gdb-10.1-obj'
#make[1]: *** [Makefile:857: all] Error 2
#make[1]: Leaving directory '/cygdrive/c/Users/gb/workspaces/wrk_avr/ed_avr_gcc/build/gdb-10.1-obj'
#make: *** [Makefile:227: compile-gdb] Error 2

# GCC
#checking size of mp_limb_t... 0
#configure: error: Oops, mp_limb_t doesn't seem to work
#make[2]: *** [Makefile:4808: configure-gmp] Error 1
#make[2]: Leaving directory '/c/Users/gb/workspaces/wrk_avr/ed_avr_gcc/build/gcc-10.2.0-obj'
#make[1]: *** [Makefile:959: all] Error 2
#make[1]: Leaving directory '/c/Users/gb/workspaces/wrk_avr/ed_avr_gcc/build/gcc-10.2.0-obj'
#make: *** [Makefile:194: compile-gcc] Error 2
