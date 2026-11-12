# Memory Layout

| Address | Purpose |
|---|---|
| 0x00000 - 0x004FF | BIOS Data Area and interrupt vectors |
| 0x01000 - 0x031FF | Reserved kernel loading region |
| 0x07C00 | Bootloader |
| 0x90000 | Kernel stack |
| 0xB8000 | VGA text framebuffer |

## Notes

The kernel is loaded at physical address 0x1000.

The maximum kernel binary size is 8704 bytes.

The stack is initialized at 0x90000 and grows downward.

The VGA framebuffer uses 80 columns and 25 rows.
Each text cell occupies two bytes.
