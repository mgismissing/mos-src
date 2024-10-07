#include "stdint.h"
#include "stdio.h"
#include "interrupt.h"
#include "vga.h"

void port_out(uint16_t port, uint8_t value) {
    asm volatile ("outb %1, %0" : : "dN" (port), "a" (value));
    return;
}

uint8_t port_in(uint16_t port) {
    uint8_t value;
    asm volatile ("inb %1, %0" : "=a" (value) : "dN" (port));
    return value;
}

void *memset(void *dest, char val, uint32_t count) {
    uint8_t *temp = (uint8_t*) dest;
    for (; count != 0; count--) {
        *temp++ = val;
    }
}

bool kb_keys[256] = {0};
uint8_t kb_keys_last = 0;

bool kb_kstatus_caps = false;

const uint16_t kb_chars_lowercase_eng[128] = {
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_ESC, '1', '2', '3', '4', '5', '6', '7', '8',
    '9', '0', '-', '=', '\b', '\t', 'q', 'w', 'e', 'r',
    't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n', IO_KB_CHAR_CTRL_L,
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',
    '\'', '`', IO_KB_CHAR_SHIFT_L, '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',',
    '.', '/', IO_KB_CHAR_SHIFT_R, '*', IO_KB_CHAR_ALT, ' ', IO_KB_CHAR_LOCK_CAPS, IO_KB_CHAR_F1, IO_KB_CHAR_F2, IO_KB_CHAR_F3,
    IO_KB_CHAR_F4, IO_KB_CHAR_F5, IO_KB_CHAR_F6, IO_KB_CHAR_F7, IO_KB_CHAR_F8, IO_KB_CHAR_F9, IO_KB_CHAR_F10, IO_KB_CHAR_LOCK_NUM, IO_KB_CHAR_LOCK_SCROLL,
    IO_KB_CHAR_HOME, IO_KB_CHAR_ARROW_UP, IO_KB_CHAR_PAGE_UP, '-', IO_KB_CHAR_ARROW_LEFT, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_ARROW_RIGHT,
    '+', IO_KB_CHAR_END, IO_KB_CHAR_ARROW_DOWN, IO_KB_CHAR_PAGE_DOWN, IO_KB_CHAR_INSERT, IO_KB_CHAR_DELETE, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_F11, IO_KB_CHAR_F12, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN
};

const uint16_t kb_chars_uppercase_eng[128] = {
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_ESC, '!', '@', '#', '$', '%', '^', '&', '*',
    '(', ')', '_', '+', '\b', '\t', 'Q', 'W', 'E', 'R',
    'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n', IO_KB_CHAR_CTRL_L,
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':',
    '"', '~', IO_KB_CHAR_SHIFT_L, '|', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<',
    '>', '?', IO_KB_CHAR_SHIFT_R, '*', IO_KB_CHAR_ALT, ' ', IO_KB_CHAR_LOCK_CAPS, IO_KB_CHAR_F1, IO_KB_CHAR_F2, IO_KB_CHAR_F3,
    IO_KB_CHAR_F4, IO_KB_CHAR_F5, IO_KB_CHAR_F6, IO_KB_CHAR_F7, IO_KB_CHAR_F8, IO_KB_CHAR_F9, IO_KB_CHAR_F10, IO_KB_CHAR_LOCK_NUM, IO_KB_CHAR_LOCK_SCROLL,
    IO_KB_CHAR_HOME, IO_KB_CHAR_ARROW_UP, IO_KB_CHAR_PAGE_UP, '-', IO_KB_CHAR_ARROW_LEFT, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_ARROW_RIGHT,
    '+', IO_KB_CHAR_END, IO_KB_CHAR_ARROW_DOWN, IO_KB_CHAR_PAGE_DOWN, IO_KB_CHAR_INSERT, IO_KB_CHAR_DELETE, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_F11, IO_KB_CHAR_F12, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN
};

const uint16_t kb_chars_lowercase[128] = {
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_ESC, '1', '2', '3', '4', '5', '6', '7', '8',
    '9', '0', '-', '=', '\b', '\t', 'q', 'w', 'e', 'r',
    't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n', IO_KB_CHAR_CTRL_L,
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',
    '\'', '`', IO_KB_CHAR_SHIFT_L, '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',',
    '.', '/', IO_KB_CHAR_SHIFT_R, '*', IO_KB_CHAR_ALT, ' ', IO_KB_CHAR_LOCK_CAPS, IO_KB_CHAR_F1, IO_KB_CHAR_F2, IO_KB_CHAR_F3,
    IO_KB_CHAR_F4, IO_KB_CHAR_F5, IO_KB_CHAR_F6, IO_KB_CHAR_F7, IO_KB_CHAR_F8, IO_KB_CHAR_F9, IO_KB_CHAR_F10, IO_KB_CHAR_LOCK_NUM, IO_KB_CHAR_LOCK_SCROLL,
    IO_KB_CHAR_HOME, IO_KB_CHAR_ARROW_UP, IO_KB_CHAR_PAGE_UP, '-', IO_KB_CHAR_ARROW_LEFT, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_ARROW_RIGHT,
    '+', IO_KB_CHAR_END, IO_KB_CHAR_ARROW_DOWN, IO_KB_CHAR_PAGE_DOWN, IO_KB_CHAR_INSERT, IO_KB_CHAR_DELETE, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_F11, IO_KB_CHAR_F12, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN
};

const uint16_t kb_chars_uppercase[128] = {
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_ESC, '!', '@', '#', '$', '%', '^', '&', '*',
    '(', ')', '_', '+', '\b', '\t', 'Q', 'W', 'E', 'R',
    'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n', IO_KB_CHAR_CTRL_L,
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':',
    '"', '~', IO_KB_CHAR_SHIFT_L, '|', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<',
    '>', '?', IO_KB_CHAR_SHIFT_R, '*', IO_KB_CHAR_ALT, ' ', IO_KB_CHAR_LOCK_CAPS, IO_KB_CHAR_F1, IO_KB_CHAR_F2, IO_KB_CHAR_F3,
    IO_KB_CHAR_F4, IO_KB_CHAR_F5, IO_KB_CHAR_F6, IO_KB_CHAR_F7, IO_KB_CHAR_F8, IO_KB_CHAR_F9, IO_KB_CHAR_F10, IO_KB_CHAR_LOCK_NUM, IO_KB_CHAR_LOCK_SCROLL,
    IO_KB_CHAR_HOME, IO_KB_CHAR_ARROW_UP, IO_KB_CHAR_PAGE_UP, '-', IO_KB_CHAR_ARROW_LEFT, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_ARROW_RIGHT,
    '+', IO_KB_CHAR_END, IO_KB_CHAR_ARROW_DOWN, IO_KB_CHAR_PAGE_DOWN, IO_KB_CHAR_INSERT, IO_KB_CHAR_DELETE, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_F11, IO_KB_CHAR_F12, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN, IO_KB_CHAR_UNKNOWN,
    IO_KB_CHAR_UNKNOWN
};

uint16_t kb_scancode_to_char(uint8_t scancode, bool caps) {
    if (caps == 0) {
        return kb_chars_lowercase[scancode];
    } else {
        return kb_chars_uppercase[scancode];
    }
}

bool kb_is_scancode_pressed(uint8_t scancode) {
    return kb_keys[scancode];
}

uint8_t kb_get_last_scancode() {
    return kb_keys_last;
}
uint8_t kb_get_last_scancode_press_state() {
    return kb_keys[kb_keys_last];
}
bool kb_get_caps_state() {
    return kb_kstatus_caps;
}

uint8_t kb_wait_for_scancode() {
    while (kb_keys[kb_keys_last] == 0);
    return kb_keys_last;
}

void kb_clear_scancodes_press_states() {
    for (uint8_t key = 0; key < 256; key++) {
        kb_keys[key] = 0;
    }
}

void kb_handler(struct InterruptRegisters *regs) {
    uint8_t scancode = port_in(IO_KB_PORT_STATUS) & 0x7F;
    uint8_t press = !((port_in(IO_KB_PORT_STATUS) & 0x80) >> 7);
    kb_keys[scancode] = press;
    kb_keys_last = scancode;

    switch (scancode) {
        case IO_KB_SCANCODE_ESC:
        case IO_KB_SCANCODE_CTRL_L:
        case IO_KB_SCANCODE_ALT:
        case IO_KB_SCANCODE_F1:
        case IO_KB_SCANCODE_F2:
        case IO_KB_SCANCODE_F3:
        case IO_KB_SCANCODE_F4:
        case IO_KB_SCANCODE_F5:
        case IO_KB_SCANCODE_F6:
        case IO_KB_SCANCODE_F7:
        case IO_KB_SCANCODE_F8:
        case IO_KB_SCANCODE_F9:
        case IO_KB_SCANCODE_F10:
        case IO_KB_SCANCODE_F11:
        case IO_KB_SCANCODE_F12:
            break;

        case IO_KB_SCANCODE_LOCK_CAPS:
            kb_kstatus_caps = !(kb_kstatus_caps);
            break;
    }
}

void kb_init() {
    irq_install_handler(1, &kb_handler);
}

void snd_play_tone(uint16_t freq, uint16_t duration_ms) {
    uint32_t divisor = 1193180 / freq;

    port_out(IO_PIT_PORT_CMD, 0b10110110);
    port_out(IO_PIT_PORT_DATA_CH_2, (uint8_t)(divisor & 0xFF));
    port_out(IO_PIT_PORT_DATA_CH_2, (uint8_t)((divisor >> 8) & 0xFF));
    
    uint8_t tmp = port_in(IO_KB_PORT_DATA);
    if (tmp != tmp | 3) {
        port_out(IO_KB_PORT_DATA, tmp | 3);
    }
    return;
}