#!/usr/bin/env bash
cd riscv-qemu
patch --forward hw/riscv/boot.c < ../patches/qemu-kernel-reloc.patch || true
cd ..

# linux patch
cd riscv-linux
patch -p0 --forward <  ../patches/linux-cma.patch || true
cd ..

# buildroot patch
cd buildroot
patch -p1 --forward <  ../patches/buildroot-check-kernel-headers.patch || true
cd ..

# riscv-pk patch
cd riscv-pk
patch -p1 --forward <  ../patches/riscv-pk-qemu-misa.patch || true
cd ..

