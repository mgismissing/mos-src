bits 32

%macro isr_noerr_code 1
    global isr%1
    isr%1:
        cli
        push long 0
        push long %1
        jmp isr_common_stub
%endmacro

%macro isr_err_code 1
    global isr%1
    isr%1:
        cli
        push long %1
        jmp isr_common_stub
%endmacro

%macro irq 2
    global irq%1
    irq%1:
        cli
        push long 0
        push long %2
        jmp irq_common_stub
%endmacro

SCR_ADDRESS_START   equ  0xB800
SCR_WIDTH           equ  0xA0
SCR_HEIGHT          equ  0x32
SCR_SIZE            equ  0x0FA0
SCR_ADDRESS_END     equ  0xD740
SCR_HEIGHT_MIDDLE   equ  0x07D0

SCR13_ADDRESS_START   equ  0xA0000
SCR13_WIDTH           equ  0x0140
SCR13_HEIGHT          equ  0x00C8
SCR13_SIZE            equ  0xFA00
SCR13_ADDRESS_END     equ  0xAFA00
SCR13_WIDTH_MIDDLE    equ  0x00A0
SCR13_HEIGHT_MIDDLE   equ  0x7D00

%include "macros.asm"

extern kernel32

global _start
_start:
    ; Set up the stack
    mov esp, 0x90000
    
    call kernel32
pm_end:
    jmp $

global idt_flush
idt_flush:
    mov eax, [esp+4]
    lidt [eax]
    sti
    ret

isr_noerr_code 0
isr_noerr_code 1
isr_noerr_code 2
isr_noerr_code 3
isr_noerr_code 4
isr_noerr_code 5
isr_noerr_code 6
isr_noerr_code 7
isr_err_code 8
isr_noerr_code 9
isr_err_code 10
isr_err_code 11
isr_err_code 12
isr_err_code 13
isr_err_code 14
isr_noerr_code 15
isr_noerr_code 16
isr_noerr_code 17
isr_noerr_code 18
isr_noerr_code 19
isr_noerr_code 20
isr_noerr_code 21
isr_noerr_code 22
isr_noerr_code 23
isr_noerr_code 24
isr_noerr_code 25
isr_noerr_code 26
isr_noerr_code 27
isr_noerr_code 28
isr_noerr_code 29
isr_noerr_code 30
isr_noerr_code 31
isr_noerr_code 128
isr_noerr_code 177

irq 0, 32
irq 1, 33
irq 2, 34
irq 3, 35
irq 4, 36
irq 5, 37
irq 6, 38
irq 7, 39
irq 8, 40
irq 9, 41
irq 10, 42
irq 11, 43
irq 12, 44
irq 13, 45
irq 14, 46
irq 15, 47

extern isr_handler
isr_common_stub:
    pusha
    mov eax, ds
    push eax
    mov eax, cr2
    push eax

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    push esp
    call isr_handler

    add esp, 8
    pop ebx
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx

    popa
    add esp, 8
    sti
    iret

extern irq_handler
irq_common_stub:
    pusha
    mov eax, ds
    push eax
    mov eax, cr2
    push eax

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    push esp
    call irq_handler

    add esp, 8
    pop ebx
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx

    popa
    add esp, 8
    sti
    iret

%include "lib32/fonts/0.asm"
%include "lib32/fonts/1.asm"