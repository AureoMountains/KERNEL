ASM = nasm
CC = gcc
LD = ld
OBJCOPY = objcopy

QEMU = qemu-system-i386

BUILD = build

BOOT_SRC = boot/boot.asm
KERNEL_SRC = kernel/kernel.c kernel/vga.c

BOOT_BIN = $(BUILD)/boot.bin
KERNEL_ELF = $(BUILD)/kernel.elf
KERNEL_BIN = $(BUILD)/kernel.bin
OS_IMAGE = $(BUILD)/os-image.bin

INCLUDES = -Iinclude

CFLAGS = -m32 \
         -std=gnu11 \
         -ffreestanding \
         -fno-pie \
         -fno-pic \
         -fno-stack-protector \
         -fno-builtin \
         -fno-asynchronous-unwind-tables \
         -fno-unwind-tables \
         -mno-sse \
         -mno-mmx \
         -Wall \
         -Wextra \
         -Wpedantic \
         -O2 \
         $(INCLUDES)

LDFLAGS = -m elf_i386 \
          -T linker/linker.ld \
          -nostdlib

KERNEL_MAX_SIZE = 8704

.PHONY: all run clean inspect check

all: $(OS_IMAGE)

$(BUILD):
	mkdir -p $(BUILD)

$(BOOT_BIN): $(BOOT_SRC) | $(BUILD)
	$(ASM) -f bin $< -o $@

$(BUILD)/kernel.o: kernel/kernel.c include/vga.h | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/vga.o: kernel/vga.c include/vga.h | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(KERNEL_ELF): $(BUILD)/kernel.o $(BUILD)/vga.o linker/linker.ld
	$(LD) $(LDFLAGS) -o $@ \
		$(BUILD)/kernel.o $(BUILD)/vga.o

$(KERNEL_BIN): $(KERNEL_ELF)
	$(OBJCOPY) -O binary $< $@
	@test $$(wc -c < $@) -le $(KERNEL_MAX_SIZE) || \
		(echo "Kernel exceeds 17-sector limit"; exit 1)

$(OS_IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	@test $$(wc -c < $(BOOT_BIN)) -eq 512 || \
		(echo "Boot sector must be exactly 512 bytes"; exit 1)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $@
	truncate -s 9216 $@

run: $(OS_IMAGE)
	$(QEMU) -drive format=raw,file=$(OS_IMAGE),if=floppy

inspect: $(KERNEL_ELF)
	readelf -h -S -s $(KERNEL_ELF)

check: $(BOOT_BIN)
	@test "$$(od -An -tx1 -j510 -N2 $(BOOT_BIN) | tr -d ' \n')" = "55aa"
	@echo "Boot sector signature: OK"

clean:
	rm -rf $(BUILD)
