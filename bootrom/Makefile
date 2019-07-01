CC = riscv32-unknown-elf-gcc
OBJCOPY= riscv32-unknown-elf-objcopy
CFLAGS = \
	-march=rv32imaf -mcmodel=medany -mabi=ilp32 \
	-nostdlib -nostartfiles -fno-common -std=gnu11 \
	-static \
	-fPIC \
	-O2 -Wall\

# ^ consider taking out -g -Og and putting in -O2

bootloaders=\
	bootrom.elf

.PHONY: all
all: $(bootloaders)

.PHONY: clean
clean:
	rm -f bootrom.elf

bootrom_sources = \
	./bootloader.S \
	./bootloader.c \
	./ed25519/*.c \
	./sha3/*.c

%.elf: $(bootrom_sources) bootloader.lds
	$(CC) $(CFLAGS) -I./ -L . -T bootloader.lds -o $@ $(bootrom_sources)
