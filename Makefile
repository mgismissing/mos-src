TOTAL_SECTORS=128

GCC = cc/bin/i686-elf-gcc
GCC_FLAGS = -fno-stack-protector -fno-builtin -m32 -g
LD = cc/bin/i686-elf-ld
LD_FLAGS = -Ttext 0x00010000 --oformat binary

all: build

build:
	nasm -f elf32 pm/main.asm -o obj/main.o
	wsl $(GCC) $(GCC_FLAGS) -c pm/kernel.c -o obj/kernel.o
	wsl $(GCC) $(GCC_FLAGS) -c pm/notepad/notepad.c -o obj/notepad/notepad.o
	wsl $(GCC) $(GCC_FLAGS) -c pm/doom/doom.c -o obj/doom/doom.o
	wsl $(GCC) $(GCC_FLAGS) -c pm/gd/gd.c -o obj/gd/gd.o
	wsl $(GCC) $(GCC_FLAGS) -c lib32/string.c -o obj/string.o
	wsl $(GCC) $(GCC_FLAGS) -c lib32/math.c -o obj/math.o
	wsl $(GCC) $(GCC_FLAGS) -c lib32/interrupt.c -o obj/interrupt.o
	wsl $(GCC) $(GCC_FLAGS) -c lib32/stdio.c -o obj/stdio.o
	wsl $(GCC) $(GCC_FLAGS) -c lib32/vga.c -o obj/vga.o
	wsl $(GCC) $(GCC_FLAGS) -c lib32/multitask.c -o obj/multitask.o
	wsl $(GCC) $(GCC_FLAGS) -c lib32/timer.c -o obj/timer.o
	wsl $(LD) $(LD_FLAGS) obj/main.o obj/kernel.o obj/string.o obj/interrupt.o obj/vga.o obj/timer.o obj/multitask.o obj/stdio.o obj/math.o obj/notepad/notepad.o obj/doom/doom.o obj/gd/gd.o -o kernel.bin

	nasm -f bin boot.asm -o boot16.bin

	wsl cat boot16.bin kernel.bin > boot.bin

	rmdir /s /q iso
	wsl dd if=/dev/zero of=mos.img bs=1024 count=1440
	wsl dd if=boot.bin of=mos.img seek=0 count=${TOTAL_SECTORS} conv=notrunc
	del bin\boot.bin
	copy boot.bin bin\boot.bin
	del boot.bin
	mkdir iso
	copy mos.img iso\mos.img
	del mos.img
	wsl genisoimage -V 'MOS' -input-charset iso8859-1 -o mos.iso -b mos.img -hide mos.img iso
	copy mos.iso iso\mos.iso
	del mos.iso

run-qemu:
	qemu-system-x86_64 -cdrom iso\mos.iso

run-qemu-debug:
	qemu-system-x86_64 -s -S -cdrom iso\mos.iso

run-vbox:
	vboxmanage startvm MagnesiumOS