pm_enter:
    mov ah, 0x00                ; Clear screen
    mov al, 0x13
    int 0x10

    cli                         ; Disable interrupts
    lgdt [gdt_descriptor]       ; Load Global Descriptor Table

    mov eax, cr0                ; Switch to Protected Mode
    or eax, 0x01
    mov cr0, eax

    jmp GDT_SEGMENTC:pm_start   ; Far jump to flush CPU pipeline (Pipelining: decoding and fetching multiple instructions simultaneously)