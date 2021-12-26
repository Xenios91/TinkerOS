default: run

.PHONY: default build run clean

cargo:
	xargo build --release --target x86_64-unknown-tinkeros-gnu
	
target/multiboot_header.o: src/boot/multiboot_header.asm
		mkdir -p target
		nasm -f elf64 src/boot/multiboot_header.asm -o target/multiboot_header.o

target/boot.o: src/boot/boot.asm
		mkdir -p target
		nasm -f elf64 src/boot/boot.asm -o target/boot.o

target/kernel.bin: target/multiboot_header.o target/boot.o src/boot/linker.ld cargo
		ld -n -o target/kernel.bin -T src/boot/linker.ld target/multiboot_header.o target/boot.o target/x86_64-unknown-tinkeros-gnu/release/libtinkeros.a
		
target/os.iso: target/kernel.bin src/boot/grub.cfg
		mkdir -p target/isofiles/boot/grub
		cp src/boot/grub.cfg target/isofiles/boot/grub
		cp target/kernel.bin target/isofiles/boot/
		grub-mkrescue -o target/os.iso target/isofiles

run: target/os.iso
		qemu-system-x86_64 -cdrom target/os.iso

clean:
		cargo clean
