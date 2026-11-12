ASM = nasm
CC = gcc
LD = ld

CFLAGS = -m32 -ffreestanding -fno-pie -nostdlib -nostartfiles
LDFLAGS = -m elf_i386 -Ttext 0x1000

all: os-image

boot.bin: boot.asm
	$(ASM) -f bin boot.asm -o boot.bin

kernel.o: kernel.c
	$(CC) $(CFLAGS) -c kernel.c -o kernel.o

kernel.bin: kernel.o
	$(LD) $(LDFLAGS) -o kernel.elf kernel.o
	objcopy -O binary kernel.elf kernel.bin

os-image: boot.bin kernel.bin
	cat boot.bin kernel.bin > os-image.bin

run: os-image
	qemu-system-i386 -drive format=raw,file=os-image.bin

clean:
	rm -f *.bin *.o *.elf
