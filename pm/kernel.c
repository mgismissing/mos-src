#include "../lib32/stdint.h"
#include "../lib32/vga.h"
#include "../lib32/stdio.h"
#include "../lib32/interrupt.h"

void kernel32() {
    //idt_init(); // triple faults the cpu idk
    m13_draw_rect(0, 16, 16, 0x0E);
    //kb_init();
    return;
}