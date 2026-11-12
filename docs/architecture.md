# System Architecture

## Overview

KERNEL is an experimental 32-bit x86 operating system project.

It uses a BIOS boot sector written in NASM and a freestanding C kernel.

## Components

### Bootloader

Responsible for:

- Initializing the real-mode environment.
- Preserving the BIOS boot drive.
- Loading the kernel using BIOS INT 13h.
- Enabling the A20 gate.
- Loading the Global Descriptor Table.
- Entering 32-bit Protected Mode.
- Initializing the stack.
- Transferring execution to the kernel.

### Kernel

Responsible for:

- Initializing the BSS section.
- Initializing the VGA text-mode driver.
- Printing kernel status messages.
- Halting the CPU after initialization.

### VGA Driver

Uses memory-mapped I/O at physical address 0xB8000.

The driver supports:

- Character output.
- Color configuration.
- Screen clearing.
- Newline handling.
- Carriage returns.
- Backspace.
- Vertical scrolling.

## Execution Environment

- BIOS boot
- x86 real mode
- x86 32-bit Protected Mode
- Flat memory model
- VGA text mode
