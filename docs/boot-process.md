# Boot Process

## 1. BIOS Initialization

The BIOS loads the first sector of the boot device to physical
address 0x7C00 and transfers execution to it.

## 2. Real Mode Setup

The bootloader initializes the data, extra, and stack segments.

The stack is positioned at 0x7C00.

## 3. Kernel Loading

BIOS INT 13h reads 17 sectors starting at sector 2.

The kernel is loaded at physical address 0x1000.

## 4. A20 Gate

The bootloader enables the A20 gate through port 0x92.

## 5. Global Descriptor Table

The GDT defines:

- Null descriptor.
- 32-bit code segment.
- 32-bit data segment.

## 6. Protected Mode

CR0.PE is set to enable Protected Mode.

A far jump reloads CS using the code segment selector.

## 7. Kernel Entry

The bootloader initializes the segment registers and stack.

Execution is transferred to physical address 0x1000.

## 8. Kernel Initialization

The kernel clears BSS, initializes VGA, prints status messages,
and halts the processor.
