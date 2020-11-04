patch -p1 < patches/conf-imac.patch
cd riscv-pk/
patch -p1 < ../patches/riscv-pk-qemu-misa.patch
cd ../

