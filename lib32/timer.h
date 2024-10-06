void timer_init();
void timer_on_irq0(struct InterruptRegisters *regs);
uint32_t timer_get_current_ticks();
void timer_sleep(uint32_t ticks);