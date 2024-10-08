#include "../../lib32/stdint.h"
#include "../../lib32/vga.h"
#include "../../lib32/stdio.h"
#include "../../lib32/string.h"

#include "gerg.h"

uint8_t gerg_img_icon[] = {
    0xFF, 0xFF, 0x00, 0x7C, 0x17, 0x7C, 0x7C, 0x00,
    0xFF, 0xFF, 0x34, 0x7C, 0x7C, 0x7C, 0x7C, 0x1B,
    0xFF, 0x7C, 0x34, 0x34, 0x34, 0x34, 0x00, 0x1B,
    0xFF, 0x34, 0x34, 0x34, 0x34, 0x7C, 0x1B, 0x1B,
    0x7C, 0x34, 0x34, 0x34, 0x34, 0x00, 0x0E, 0x1B,
    0xFF, 0xFF, 0x00, 0x1B, 0x1B, 0x0E, 0x0E, 0x0E,
    0xFF, 0xFF, 0x00, 0x1B, 0x1B, 0x1B, 0x0E, 0x0E,
    0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00
};

uint8_t gerg_interpreter(coords_index start_pos, char source_code[]) {
    m13_draw_window(start_pos, 320, 200, "GERG INTERPRETER", gerg_img_icon, 0x0F, 0x12, 0x11, 0x13, 0);
    uint8_t offset = 0;
    uint8_t loop_offset = offset;
    uint16_t pos = 0;
    uint8_t cells[32] = {0};
    uint8_t sel = 0;
    char* cmd = "   ";
    uint8_t line = 0;
    while ((source_code[offset] != 0) && (source_code[offset+1] != 0) && (source_code[offset+2] != 0)) {
        *(cmd) = source_code[offset];
        *(cmd+1) = source_code[offset+1];
        *(cmd+2) = source_code[offset+2];

        if (!strcmp("END", cmd)) {
            pos = 0;
            line++;
            m13_printf(start_pos + m13_coords_to_index(2 + (pos * 4), 13 + (line * 8)), "Program terminated.", 0x0E, 0xFF, 1, 0);
            return 0;
        } else if (!strcmp("DEC", cmd)) {
            cells[sel]--;
        } else if (!strcmp("INC", cmd)) {
            cells[sel]++;
        } else if (!strcmp("LOG", cmd)) {
            m13_putchar(start_pos + m13_coords_to_index(2 + (pos * 4), 13 + (line * 8)), cells[sel], 0x0F, 0xFF, 1, 0);
            pos++;
        } else if (!strcmp("MVL", cmd)) {
            if (sel > 0) {
                sel--;
            } else {
                sel = 31;
            }
        } else if (!strcmp("MVR", cmd)) {
            if (sel < 31) {
                sel++;
            } else {
                sel = 0;
            }
        } else if (!strcmp("NUL", cmd)) {
            cells[sel] = 0;
        } else if (!strcmp("ST", cmd)) {
            cells[sel] = *(cmd+2);
        
        // Loops
        } else if (!strcmp("(", cmd)) {
            loop_offset = offset;
        } else if (!strcmp(")Z", cmd)) {
            if (cells[sel] > 0) {
                offset = loop_offset;
            }
        
        // Other
        } else if (!strcmp("S", cmd)) {
            char char1 = *(cmd+1);
            char char2 = *(cmd+2);

            uint8_t value = 0;

            switch (char1) {
                case '0':
                    value += 0 * 16;
                    break;
                case '1':
                    value += 1 * 16;
                    break;
                case '2':
                    value += 2 * 16;
                    break;
                case '3':
                    value += 3 * 16;
                    break;
                case '4':
                    value += 4 * 16;
                    break;
                case '5':
                    value += 5 * 16;
                    break;
                case '6':
                    value += 6 * 16;
                    break;
                case '7':
                    value += 7 * 16;
                    break;
                case '8':
                    value += 8 * 16;
                    break;
                case '9':
                    value += 9 * 16;
                    break;
                case 'A':
                    value += 10 * 16;
                    break;
                case 'B':
                    value += 11 * 16;
                    break;
                case 'C':
                    value += 12 * 16;
                    break;
                case 'D':
                    value += 13 * 16;
                    break;
                case 'E':
                    value += 14 * 16;
                    break;
                case 'F':
                    value += 15 * 16;
                    break;
            }

            switch (char2) {
                case '0':
                    value += 0;
                    break;
                case '1':
                    value += 1;
                    break;
                case '2':
                    value += 2;
                    break;
                case '3':
                    value += 3;
                    break;
                case '4':
                    value += 4;
                    break;
                case '5':
                    value += 5;
                    break;
                case '6':
                    value += 6;
                    break;
                case '7':
                    value += 7;
                    break;
                case '8':
                    value += 8;
                    break;
                case '9':
                    value += 9;
                    break;
                case 'A':
                    value += 10;
                    break;
                case 'B':
                    value += 11;
                    break;
                case 'C':
                    value += 12;
                    break;
                case 'D':
                    value += 13;
                    break;
                case 'E':
                    value += 14;
                    break;
                case 'F':
                    value += 15;
                    break;
            }

            cells[sel] = value;
        }

        if (pos >= 79) {pos = 0; line++;};

        offset += 4;
    }
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (line * 8)), "Program killed.", 0x0C, 0xFF, 1, 0);
    return 1;
}

uint8_t gerg_main(coords_index start_pos) {
    char buffer[512] = {0};
    uint16_t curr_offset = 0;
    uint16_t curr_pos = 0;
    uint8_t scancode;
    bool hide_cursor = false;
    m13_draw_window(start_pos, 320, 200, "GERG INTERPRETER", gerg_img_icon, 0x0F, 0x12, 0x11, 0x13, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (8 * 0)), "Start typing... (Press F5 to run)", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (8 * 2)), "Syntax: \"CMD,CMD,CMD,CMD...,END\"", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (8 * 3)), "Commands:", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (8 * 4)), "DEC / INC: Decrements / Increments the value in the selected cell.", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (8 * 5)), "END: Ends the program.", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (8 * 6)), "LOG: Prints the value in the selected cell to the screen.", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (8 * 7)), "MVL / MVR: Changes selection.", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (8 * 8)), "NUL: Resets the value in the current cell.", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (8 * 9)), "STx: Stores the literal character x in the selected cell.", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (8 * 10)), "Sxx: Stores the hex value x in the selected cell.", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (8 * 11)), "(  : Start of a loop.", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13 + (8 * 12)), ")Z : Loops back only if the value in the selected cell is not 0.", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 190), "PRESS ESC TO EXIT. THE FILE IS TEMPORARY AND WILL NOT SAVE BETWEEN SESSIONS.", 0x0C, 0xFF, 1, 0);

    while (1) {
        scancode = kb_wait_for_scancode();
        m13_draw_window(start_pos, 320, 200, "GERG INTERPRETER", gerg_img_icon, 0x0F, 0x12, 0x11, 0x13, 0);
        m13_printf(start_pos + m13_coords_to_index(2, 190), "PRESS ESC TO EXIT. THE FILE IS TEMPORARY AND WILL NOT SAVE BETWEEN SESSIONS.", 0x0C, 0xFF, 1, 0);
        if (scancode == 0x01 /* esc */) {
            return 0;
        } else if (scancode == 0x0E /* backspace */) {
            for (uint8_t i = 0; i < (1 + kb_get_caps_state() * 3); i++) {
                if (curr_offset > 0) {
                    if (buffer[curr_offset-1] == '\n' && buffer[curr_offset-2] == '\r') {
                        curr_offset--;
                        buffer[curr_offset] = 0;
                        curr_offset--;
                        buffer[curr_offset] = 0;
                    } else {
                        curr_offset--;
                        buffer[curr_offset] = 0;
                    }
                }
            }
        } else if (scancode == IO_KB_SCANCODE_F5) {
            gerg_interpreter(start_pos, buffer);
            while (kb_is_scancode_pressed(scancode));
            continue;
        } else if (curr_offset < 512) {
            if (scancode == 0x1C) {
                buffer[curr_offset] = '\r';
                curr_offset++;
                buffer[curr_offset] = '\n';
                curr_offset++;
            } else {
                uint16_t character = kb_scancode_to_char(scancode, kb_get_caps_state());
                if (character <= 0xFF) {
                    buffer[curr_offset] = character;
                    curr_offset++;
                }
            }
        }
        curr_pos = 0;
        for (uint16_t offset = 0; offset < curr_offset; offset++) {
            if (buffer[offset] == '\n') {
                curr_pos += SCR13_WIDTH * 8;
            } else if ((buffer[offset] == '\r')) {
                curr_pos -= (curr_pos % SCR13_WIDTH);
            } else if ((curr_pos % SCR13_WIDTH) >= 310) {
                m13_putchar(start_pos + (curr_pos * 1) + m13_coords_to_index(2, 13), buffer[offset], 0x0F, 0xFF, 1, 0);
                curr_pos += SCR13_WIDTH * 8;
                curr_pos -= (curr_pos % SCR13_WIDTH);
            } else {
                m13_putchar(start_pos + (curr_pos * 1) + m13_coords_to_index(2, 13), buffer[offset], 0x0F, 0xFF, 1, 0);
                curr_pos += 4;
            }
        }
        m13_putchar(start_pos + (curr_pos * 1) + m13_coords_to_index(2, 13), '|', 0x0E, 0xFF, 1, 0);
        while ((kb_is_scancode_pressed(scancode)) && (scancode == kb_get_last_scancode()));
    }
}