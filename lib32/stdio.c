#include "stdint.h"
#include "interrupt.h"
#include "stdio.h"

void port_out(uint16_t port, uint8_t value) {
    asm volatile ("outb %1, %0" : : "dN" (port), "a" (value));
    return;
}

uint8_t port_in(uint16_t port) {
    uint8_t value;
    asm volatile ("inb %1, %0" : "=a" (value) : "dN" (port));
    return value;
}

#define KB_PORT_STATUS 0x60

void *memset(void *dest, char val, uint32_t count) {
    uint8_t *temp = (uint8_t*) dest;
    for (; count != 0; count--) {
        *temp++ = val;
    }
}