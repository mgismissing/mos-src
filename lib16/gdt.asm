gdt_start:
gdt_null:                               ; Must be included for error checking
    dd 0x00000000
    dd 0x00000000
gdt_code:                               ; Code segment descriptor
    dw 0xFFFF                           ; Limit
    dw 0x0000                           ; Base
    db 0x00                             ; Base
    db 0b10011010                       ; Flags
    db 0b11001111                       ; Flags
    db 0x00                             ; Base
gdt_data:                               ; Data segment descriptor
    dw 0xFFFF                           ; Limit
    dw 0x0000                           ; Base
    db 0x00                             ; Base
    db 0b10010010                       ; Flags
    db 0b11001111                       ; Flags
    db 0x00                             ; Base
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start - 1          ; Size of the GDT
    dd gdt_start

GDT_SEGMENTC    equ gdt_code - gdt_start
GDT_SEGMENTD    equ gdt_data - gdt_start