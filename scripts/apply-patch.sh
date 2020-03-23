#!/usr/bin/env bash
cd riscv-qemu
patch --forward hw/riscv/boot.c < ../patches/qemu-kernel-reloc.patch || true
patch --forward hw/riscv/virt.c < ../patches/qemu-rv32-romsize.patch || true
cd ..

# linux patch
cd riscv-linux
patch -p0 --forward <  ../patches/linux-cma.patch || true
patch -p1 --forward <  ../patches/kernel-rv32-module.patch || true
cd ..

# buildroot patch
cd buildroot
patch -p1 --forward <  ../patches/buildroot-multilib-toolchain.patch || true
cd ..

# linux driver patch
cd linux-keystone-driver
patch -p1 --forward <  ../patches/linux-keystone-driver-rv32.patch || true
cd ..

# sdk patch
cd sdk
patch -p1 --forward <  ../patches/linux-sdk-rv32.patch || true
cd ..

