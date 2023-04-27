
# Compile and Install of the AVR-GCC Toolchain

This repository contains a **make** file for compile and install of the AVR-GCC toolchain.

This **make** file can build the AVR-GCC toolchain on the following systems:
* Linux

This overall project consists of the following repositories:
* [ed_avr_gcc](https://github.com/embed-dsp/ed_avr_gcc) - Makefile for building the AVR-GCC Toolchain from source (**NOTE:** Current repository).
* [ed_avr_iss](https://github.com/embed-dsp/ed_avr_iss) - Instruction Set Simulator (ISS) for 8-bit AVR RISC Microprocessor.
* [ed_avr_core](https://github.com/embed-dsp/ed_avr_core) - Verilog implementation of 8-bit AVR RISC Microprocessor.
* [ed_avr_soc](https://github.com/embed-dsp/ed_avr_soc) - Verilog implementation of 8-bit AVR RISC System-On-Chip Microcontroller.
* [ed_avr_soc_fpga](https://github.com/embed-dsp/ed_avr_soc_fpga) - Verilog implementation of 8-bit AVR RISC System-On-Chip Microcontroller in FPGA's.


# Get Source Code

## ed_avr_gcc
Get the code for this component to a local directory on your PC.

```bash
git clone https://github.com/embed-dsp/ed_avr_gcc.git
```


# FIXME

```bash
# Download
make download
```

```bash
# Build
make build
```

```bash
# Install
make install
```

```bash
# ...
make dist
```

```bash
# Cleanup
make clean
```


# Alternative AVR-GCC Toolchains

## Microchip
* https://www.microchip.com/en-us/tools-resources/develop/microchip-studio/gcc-compilers#

## Zak Kemble
* https://blog.zakkemble.net/avr-gcc-builds

## Lumito
* https://www.lumito.net/2021/04/09/lumito-avr-gcc-releases
