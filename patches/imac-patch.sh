patch -p1 < patches/conf-imac.patch
cd riscv-pk/
patch -p1 < ../patches/riscv-pk-qemu-misa.patch
cd ../sdk/rts/eyrie/
patch -p1 < ../../../patches/sdk-imac.patch
cd ../../../

