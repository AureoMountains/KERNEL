#include "vga.h"

#include <stdint.h>

static void cpu_halt(void)
{
    for (;;)
    {
        __asm__ __volatile__("hlt");
    }
}


void kernel_main(void)
{
    vga_initialize();

    vga_set_color(10, 0);

    vga_print("KERNEL INITIALIZED\n");

    vga_set_color(15, 0);

    vga_print("------------------------------\n");
    vga_print("Boot successful.\n");
    vga_print("Protected Mode: ACTIVE\n");
    vga_print("VGA Text Mode: ACTIVE\n");
    vga_print("Architecture: x86 32-bit\n");
    vga_print("------------------------------\n");

    vga_set_color(11, 0);
    vga_print("YOU ARE NOW CONNECTED.\n");

    vga_set_color(7, 0);

    cpu_halt();
}
