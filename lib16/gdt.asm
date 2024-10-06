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
gdt_code_user:                          ; Code segment descriptor
    dw 0xFFFF                           ; Limit
    dw 0x0000                           ; Base
    db 0x00                             ; Base
    db 0b11111010                       ; Flags
    db 0b11001111                       ; Flags
    db 0x00                             ; Base
gdt_data_user:                          ; Data segment descriptor
    dw 0xFFFF                           ; Limit
    dw 0x0000                           ; Base
    db 0x00                             ; Base
    db 0b11110010                       ; Flags
    db 0b11001111                       ; Flags
    db 0x00                             ; Base
tss:
    dd 0x00000000                       ; Previous TSS
    dd 0x00000000                       ; esp0
    dd 0x00000000                       ; ss0
    dd 0x00000000                       ; esp1
    dd 0x00000000                       ; ss1
    dd 0x00000000                       ; esp2
    dd 0x00000000                       ; ss2
    dd 0x00000000                       ; cr3
    dd 0x00000000                       ; eip
    dd 0x00000000                       ; eflags
    dd 0x00000000                       ; eax
    dd 0x00000000                       ; ecx
    dd 0x00000000                       ; edx
    dd 0x00000000                       ; ebx
    dd 0x00000000                       ; esp
    dd 0x00000000                       ; ebp
    dd 0x00000000                       ; esi
    dd 0x00000000                       ; edi
    dd 0x00000000                       ; es
    dd 0x00000000                       ; cs
    dd 0x00000000                       ; ss
    dd 0x00000000                       ; ds
    dd 0x00000000                       ; fs
    dd 0x00000000                       ; gs
    dd 0x00000000                       ; ldt
    dd 0x00000000                       ; trap
    dd 0x00000000                       ; iomap_base
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start - 1          ; Size of the GDT
    dd gdt_start

GDT_SEGMENTC    equ gdt_code - gdt_start
GDT_SEGMENTD    equ gdt_data - gdt_start