#include <stdint.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_MEMORY (uint16_t*)0xB8000

static uint16_t* const vga = VGA_MEMORY;

static int row = 0;
static int col = 0;
static uint8_t color = 0x07;

static inline uint16_t vga_entry(unsigned char c, uint8_t color) {
    return (uint16_t)c | (uint16_t)color << 8;
}

void vga_clear() {
    for (int y = 0; y < VGA_HEIGHT; y++) {
        for (int x = 0; x < VGA_WIDTH; x++) {
            vga[y * VGA_WIDTH + x] = vga_entry(' ', color);
        }
    }
    row = 0;
    col = 0;
}

void vga_putchar(char c) {
    if (c == '\n') {
        col = 0;
        row++;
        return;
    }

    vga[row * VGA_WIDTH + col] = vga_entry(c, color);
    col++;

    if (col >= VGA_WIDTH) {
        col = 0;
        row++;
    }
}

void vga_print(const char* str) {
    int i = 0;
    while (str[i]) {
        vga_putchar(str[i]);
        i++;
    }
}

void vga_set_color(uint8_t fg, uint8_t bg) {
    color = (bg << 4) | (fg & 0x0F);
}

void kernel_main() {
    vga_set_color(15, 0);
    vga_clear();

    vga_print("Boot successful.\n");
    vga_print("Protected Mode Active.\n");
    vga_print("vga working, thats it bitch.\n");

    while (1) {
        __asm__ __volatile__("hlt");
    }
}
