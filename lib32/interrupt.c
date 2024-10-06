#include "stdint.h"
#include "stdio.h"
#include "vga.h"
#include "interrupt.h"

#define IDT_FLAGS_TASK          0b10000101
#define IDT_FLAGS_TRAP_16       0b10000111
#define IDT_FLAGS_TRAP_32       0b10001111
#define IDT_FLAGS_INTERRUPT_16  0b10000110
#define IDT_FLAGS_INTERRUPT_32  0b10001110

struct idt_entry_struct idt_entries[256];
struct idt_ptr_struct idt_ptr;

extern void idt_flush(uint32_t);

void idt_init() {
    idt_ptr.limit = sizeof(struct idt_entry_struct) * 256 - 1;
    idt_ptr.base = (uint32_t) &idt_entries;

    memset(&idt_entries, 0, sizeof(struct idt_entry_struct) * 256);

    // init PICs
    port_out(0x20, 0x11);
    port_out(0xA0, 0x11);

    port_out(0x21, 0x20);
    port_out(0xA1, 0x28);

    port_out(0x21, 0x04);
    port_out(0xA1, 0x02);

    port_out(0x21, 0x01);
    port_out(0xA1, 0x01);

    port_out(0x21, 0x00);
    port_out(0xA1, 0x00);

    // interrupt service routines
    idt_set_gate(0, (uint32_t)isr0, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(1, (uint32_t)isr1, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(2, (uint32_t)isr2, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(3, (uint32_t)isr3, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(4, (uint32_t)isr4, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(5, (uint32_t)isr5, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(6, (uint32_t)isr6, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(7, (uint32_t)isr7, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(8, (uint32_t)isr8, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(9, (uint32_t)isr9, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(10, (uint32_t)isr10, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(11, (uint32_t)isr11, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(12, (uint32_t)isr12, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(13, (uint32_t)isr13, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(14, (uint32_t)isr14, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(15, (uint32_t)isr15, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(16, (uint32_t)isr16, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(17, (uint32_t)isr17, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(18, (uint32_t)isr18, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(19, (uint32_t)isr19, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(20, (uint32_t)isr20, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(21, (uint32_t)isr21, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(22, (uint32_t)isr22, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(23, (uint32_t)isr23, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(24, (uint32_t)isr24, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(25, (uint32_t)isr25, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(26, (uint32_t)isr26, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(27, (uint32_t)isr27, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(28, (uint32_t)isr28, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(29, (uint32_t)isr29, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(30, (uint32_t)isr30, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(31, (uint32_t)isr31, 0x08, IDT_FLAGS_INTERRUPT_32);

    // interrupt requests
    idt_set_gate(32, (uint32_t)irq0, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(33, (uint32_t)irq1, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(34, (uint32_t)irq2, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(35, (uint32_t)irq3, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(36, (uint32_t)irq4, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(37, (uint32_t)irq5, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(38, (uint32_t)irq6, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(39, (uint32_t)irq7, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(40, (uint32_t)irq8, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(41, (uint32_t)irq9, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(42, (uint32_t)irq10, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(43, (uint32_t)irq11, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(44, (uint32_t)irq12, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(45, (uint32_t)irq13, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(46, (uint32_t)irq14, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(47, (uint32_t)irq15, 0x08, IDT_FLAGS_INTERRUPT_32);
    
    // syscalls
    idt_set_gate(128, (uint32_t)isr128, 0x08, IDT_FLAGS_INTERRUPT_32);
    idt_set_gate(177, (uint32_t)isr177, 0x08, IDT_FLAGS_INTERRUPT_32);

    idt_flush((uint32_t)&idt_ptr);
}

void idt_set_gate(uint8_t num, uint32_t base, uint16_t sel, uint8_t flags) {
    idt_entries[num].base_low = base & 0xFFFF;
    idt_entries[num].base_high = (base >> 16) & 0xFFFF;
    idt_entries[num].sel = sel;
    idt_entries[num].reserved = 0;
    idt_entries[num].flags = flags | 0x60;
    return;
}

unsigned char *exception_messages[] = {
    "ERR_MATH_ZERO",
    "ERR_DEBUG",
    "ERR_NMI",
    "ERR_BREAKPOINT",
    "ERR_DETECTED_OVERFLOW",
    "ERR_OUT_OF_BOUNDS",
    "ERR_NO_COPROCESSOR",
    "ERR_TRIPPED_AND_FELL",                 // double fault
    "ERR_COPROCESSOR_SEGMENT_OVERRUN",
    "ERR_BAD_TSS",
    "ERR_MISSING_SEGMENT",
    "ERR_STACK_FAULT",
    "ERR_PROTECTION_FAULT",
    "ERR_PAGE_FAULT",
    "ERR_UNKNOWN_INTERRUPT",
    "ERR_COPROCESSOR_FAULT",
    "ERR_ALIGNMENT_FAULT",
    "ERR_MACHINE_CHECK",
    "ERR_RESERVED_01",
    "ERR_RESERVED_02",
    "ERR_RESERVED_03",
    "ERR_RESERVED_04",
    "ERR_RESERVED_05",
    "ERR_RESERVED_06",
    "ERR_RESERVED_07",
    "ERR_RESERVED_08",
    "ERR_RESERVED_09",
    "ERR_RESERVED_0A",
    "ERR_RESERVED_0B",
    "ERR_RESERVED_0C",
    "ERR_RESERVED_0D"
};

void isr_handler(struct InterruptRegisters* regs) {
    if (regs -> int_no < 32) {
        m13_draw_rect(m13_coords_to_index(0, 0), 320, 200, 0x0C, 0x0C);
        m13_printf(m13_coords_to_index(1, 1 + (8 * 0)), "THE COMPUTER TRIPPED.", 0x00, 0x0C, 2, 0);
        m13_printf(m13_coords_to_index(1, 1 + (8 * 2)), exception_messages[regs -> int_no], 0x00, 0x0C, 1, 0);
        while(1);
    }
}

void *irq_routines[16] = {
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0
};

void irq_install_handler(int irq, void (*handler)(struct InterruptRegisters *r)) {
    irq_routines[irq] = handler;
}

void irq_uninstall_handler(int irq) {
    irq_routines[irq] = 0;
}

void irq_handler(struct InterruptRegisters* regs) {
    void (*handler)(struct InterruptRegisters * regs);
    handler = irq_routines[regs -> int_no - 32];

    if (handler) {
        handler(regs);
    }

    if (regs -> int_no >= 40) {
        port_out(0xA0, 0x20);
    }

    port_out(0x20, 0x20);
}