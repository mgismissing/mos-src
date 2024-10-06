#include "stdint.h"
#include "stdio.h"
#include "vga.h"
#include "timer.h"
#include "interrupt.h"

uint32_t ticks = 0;

const uint32_t freq = 1000;

void timer_on_irq0(struct InterruptRegisters *regs) {
    ticks++;
}

void timer_init() {
    irq_install_handler(0, &timer_on_irq0);

    // oscillator: 1.1931816666 MHz
    uint32_t divisor = 1193180 / freq;

    port_out(IO_PIT_PORT_CMD, 0b00110110);
    port_out(IO_PIT_PORT_DATA_CH_0, (uint8_t)(divisor & 0xFF));
    port_out(IO_PIT_PORT_DATA_CH_0, (uint8_t)((divisor >> 8) & 0xFF));
    return;
}

uint32_t timer_get_current_ticks() {
    return ticks;
}

void timer_sleep(uint32_t delay_ms) {
    uint32_t old_ticks = ticks;
    while(ticks < old_ticks + delay_ms / 2);
    return;
}