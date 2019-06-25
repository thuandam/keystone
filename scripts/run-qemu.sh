#!/usr/bin/env bash

HOST_PORT=${HOST_PORT:="$((3000 + RANDOM % 3000))"}

echo "**** Running QEMU SSH on port ${HOST_PORT} ****\n"

DEBUG=""

while [ "$1" != "" ]; do
if [ "$1" = "-debug" ]; then
  DEBUG="-s -S -d in_asm -D debug.log"
  shift
fi
done

./riscv-qemu/riscv32-softmmu/qemu-system-riscv32 \
    $DEBUG \
    -m 4G \
    -nographic \
    -machine virt \
    -kernel hifive-work/riscv-pk/bbl \
    -netdev user,id=net0,net=192.168.100.1/24,dhcpstart=192.168.100.128,hostfwd=tcp::${HOST_PORT}-:22 \
    -device virtio-net-device,netdev=net0
    #-bios bootrom/bootrom.elf \
