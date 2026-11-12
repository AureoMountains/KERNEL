#include "vga.h"

#define VGA_MEMORY ((volatile uint16_t *)0xB8000)

static volatile uint16_t *const vga = VGA_MEMORY;

static uint8_t current_color = 0x07;

static uint8_t cursor_row = 0;
static uint8_t cursor_col = 0;


static uint16_t vga_entry(char character)
{
    return (uint16_t)(uint8_t)character |
           ((uint16_t)current_color << 8);
}


void vga_set_color(uint8_t foreground, uint8_t background)
{
    current_color = (uint8_t)(
        ((background & 0x0F) << 4) |
        (foreground & 0x0F)
    );
}


void vga_clear(void)
{
    for (uint32_t i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++)
    {
        vga[i] = vga_entry(' ');
    }

    cursor_row = 0;
    cursor_col = 0;
}


static void vga_scroll(void)
{
    for (uint32_t row = 1; row < VGA_HEIGHT; row++)
    {
        for (uint32_t col = 0; col < VGA_WIDTH; col++)
        {
            vga[(row - 1) * VGA_WIDTH + col] =
                vga[row * VGA_WIDTH + col];
        }
    }

    for (uint32_t col = 0; col < VGA_WIDTH; col++)
    {
        vga[(VGA_HEIGHT - 1) * VGA_WIDTH + col] =
            vga_entry(' ');
    }

    cursor_row = VGA_HEIGHT - 1;
}


static void vga_newline(void)
{
    cursor_col = 0;
    cursor_row++;

    if (cursor_row >= VGA_HEIGHT)
    {
        vga_scroll();
    }
}


void vga_putchar(char c)
{
    if (c == '\n')
    {
        vga_newline();
        return;
    }

    if (c == '\r')
    {
        cursor_col = 0;
        return;
    }

    if (c == '\b')
    {
        if (cursor_col > 0)
        {
            cursor_col--;
            vga[cursor_row * VGA_WIDTH + cursor_col] =
                vga_entry(' ');
        }

        return;
    }

    vga[cursor_row * VGA_WIDTH + cursor_col] =
        vga_entry(c);

    cursor_col++;

    if (cursor_col >= VGA_WIDTH)
    {
        vga_newline();
    }
}


void vga_print(const char *str)
{
    if (str == 0)
        return;

    while (*str)
    {
        vga_putchar(*str++);
    }
}


void vga_initialize(void)
{
    vga_set_color(15, 0);
    vga_clear();
}
