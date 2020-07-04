cd sdk/rts/eyrie/
patch -p1 < ../../../patches/sdk-imac.patch

cd ../../../
patch -p1 < patches/hifive-conf-imac.patch

make clean -C sdk
make -C sdk

