void kernel_main() {
    volatile unsigned short* vga = (unsigned short*)0xB8000;

    const char* msg = "YOU ARE NOW CONNECTED";
    int i = 0;

    while (msg[i]) {
        vga[i] = (0x07 << 8) | msg[i];
        i++;
    }

    while (1) {
        __asm__ __volatile__("hlt");
    }
}
