%macro m_scr_cursor_print_string 2
    mov si, %1
    mov bx, %2
    call scr_cursor_print_string
%endmacro

%macro m_scr_cursor_print_string_special 1
    mov si, %1
    call scr_cursor_print_string_special
%endmacro

%macro m_scr_cursor_print_char 2
    mov al, %1
    mov bx, %2
    call scr_cursor_print_char
%endmacro

%macro m_scr_cursor_print_char_special 1
    mov al, %1
    call scr_cursor_print_char_special
%endmacro

%macro m_scr_cursor_print_crlf 0
    mov si, scr_str_crlf
    call scr_cursor_print_string_special
%endmacro

%macro m_scr_cursor_print_hex 2
    mov bl, %2
    mov al, %1
    call scr_cursor_print_hex
%endmacro