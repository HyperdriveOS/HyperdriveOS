ASM=nasm
SRC=src
BUILD=build

ASM_FLAGS=-f bin

.PHONY: all floppy bootloader clean mkbuild

all: floppy

# Create the floppy image
floppy: $(BUILD)/floppy.img
$(BUILD)/floppy.img: bootloader
	dd if=/dev/zero of=$(BUILD)/floppy.img bs=512 count=2880
	mkfs.fat -F 12 -n "HyOS" $(BUILD)/floppy.img
	dd if=$(BUILD)/bootloader/boot.bin of=$(BUILD)/floppy.img conv=notrunc
	mcopy -i $(BUILD)/floppy.img $(BUILD)/bootloader/boot.bin "::boot.bin"

# Assemble the bootloader
bootloader: $(BUILD)/bootloader/boot.bin
$(BUILD)/bootloader/boot.bin: mkbuild
	mkdir -p $(BUILD)/bootloader
	$(ASM) $(ASM_FLAGS) $(SRC)/bootloader/boot.asm -o $(BUILD)/bootloader/boot.bin

# Clean the build directory
clean:
	rm -rf $(BUILD)/*

mkbuild:
	mkdir -p $(BUILD)