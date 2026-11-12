#ifndef VGA_H
#define VGA_H

#include <stdint.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

void vga_initialize(void);
void vga_clear(void);
void vga_putchar(char c);
void vga_print(const char *str);
void vga_set_color(uint8_t foreground, uint8_t background);

#endif
