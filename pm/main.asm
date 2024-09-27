%include "lib32/screen13h.asm"
%include "lib32/kb.asm"

%include "pm/window.asm"
pm_main:
    call pm_win_start
pm_end:
    jmp $