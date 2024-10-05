pm_enter:
    call scr13_init

    cli                         ; Disable interrupts
    lgdt [gdt_descriptor]       ; Load Global Descriptor Table

    mov eax, cr0                ; Switch to Protected Mode
    or eax, 0x01
    mov cr0, eax

    jmp GDT_SEGMENTC:pm_start   ; Far jump to flush CPU pipeline (Pipelining: decoding and fetching multiple instructions simultaneously)

[bits 32]
pm_start:
    mov ax, GDT_SEGMENTD        ; Update segments
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x00007C00
    mov esp, ebp

    jmp main_start