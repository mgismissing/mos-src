audio_play_tone:        ; audio_play_tone(ax > Frequency, cx:dx > Duration) => None
    mov bx, ax          ; Preserve the note value by storing it in BX

    mov al, 182         ; Set up the write to the control word register
    out 0x43, al        ; Perform the write
    mov ax, bx          ; Pull back the frequency from BX
    out 0x42, al        ; Send lower byte of the frequency
    mov al, ah          ; Load higher byte of the frequency
    out 0x42, al        ; Send the higher byte

    in al, 0x61         ; Read the current keyboard controller status
    or al, 0x03         ; Turn on 0 and 1 bit, enabling the PC speaker gate and the data transfer
    out 0x61, al        ; Save the new keyboard controller status

    mov ah, 0x86        ; Load the BIOS WAIT, int15h function AH=86h
    int 0x15            ; Immediately interrupt (the delay is already in CX:DX)

    in al, 0x61         ; Read the current keyboard controller status
    and al, 0xFC        ; Turn off 0 and 1 bit, simply disabling the gate
    out 0x61, al        ; Write the new keyboard controller status
    ret                 ; Return