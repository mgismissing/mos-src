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

%macro m_win_are_mouse_coords_on_area 4
    mov ax, %1
    mov bx, %2
    mov cx, %3
    mov dx, %4
    call win_are_mouse_coords_on_area
%endmacro

%macro m_win_draw_window 5
    mov ax, (%1) + (SCR13_WIDTH * (%2))
    mov bx, %3
    mov cx, %4
    mov word [win_draw_window_title_str_pt], %5
    call win_draw_window
%endmacro

%macro m_win_draw_button 5
    mov ax, (%1) + (SCR13_WIDTH * (%2))
    mov bx, %3
    mov cx, %4
    mov word [win_draw_button_text_str_pt], %5
    call win_draw_button
%endmacro

%macro m_win_draw_pressed_button 5
    mov ax, (%1) + (SCR13_WIDTH * (%2))
    mov bx, %3
    mov cx, %4
    mov word [win_draw_button_text_str_pt], %5
    call win_draw_pressed_button
%endmacro

%macro m_win_draw_border 5
    mov ax, (%1) + (SCR13_WIDTH * (%2))
    mov bx, %3
    mov cx, %4
    mov dl, %5
    call win_draw_border
%endmacro

%macro m_win_draw_dotted_border 5
    mov ax, (%1) + (SCR13_WIDTH * (%2))
    mov bx, %3
    mov cx, %4
    mov dl, %5
    call win_draw_dotted_border
%endmacro

%macro m_pm_win_are_mouse_coords_on_area 4
    mov eax, %1
    mov ebx, %2
    mov ecx, %3
    mov edx, %4
    call win_are_mouse_coords_on_area
%endmacro

%macro m_pm_win_draw_window 5
    mov eax, (%1) + (SCR13_WIDTH * (%2))
    mov ebx, %3
    mov ecx, %4
    mov dword [pm_win_draw_window_title_str_pt], %5
    call pm_win_draw_window
%endmacro

%macro m_pm_win_draw_button 5
    mov eax, (%1) + (SCR13_WIDTH * (%2))
    mov ebx, %3
    mov ecx, %4
    mov word [pm_win_draw_button_text_str_pt], %5
    call pm_win_draw_button
%endmacro

%macro m_pm_win_draw_pressed_button 5
    mov eax, (%1) + (SCR13_WIDTH * (%2))
    mov ebx, %3
    mov ecx, %4
    mov word [pm_win_draw_button_text_str_pt], %5
    call pm_win_draw_pressed_button
%endmacro

%macro m_pm_win_draw_border 5
    mov eax, (%1) + (SCR13_WIDTH * (%2))
    mov ebx, %3
    mov ecx, %4
    mov dl, %5
    call pm_win_draw_border
%endmacro

%macro m_pm_win_draw_dotted_border 5
    mov eax, (%1) + (SCR13_WIDTH * (%2))
    mov ebx, %3
    mov ecx, %4
    mov dl, %5
    call pm_win_draw_dotted_border
%endmacro

%macro m_pm_scr13_draw_line 3
    mov eax, (%1)
    mov ebx, (%2)
    mov edl, (%3)
    call pm_scr13_draw_line
%endmacro