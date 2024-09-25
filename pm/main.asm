%include "lib32/screen13h.asm"
pm_main:
    m_pm_scr13_draw_line 0x0000, SCR13_SIZE, 0x0F
pm_end:
    jmp $