#include "../../lib32/stdint.h"
#include "../../lib32/vga.h"
#include "../../lib32/stdio.h"

#include "settings.h"

uint8_t settings_img_icon[] = {
    0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C,
    0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C,
    0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C,
    0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C,
    0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C,
    0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C,
    0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C,
    0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C, 0x00, 0x0C
};

uint8_t settings_main(coords_index start_pos) {
    m13_draw_window(start_pos, 320, 200, "SETTINGS", settings_img_icon, 0x0F, 0x12, 0x11, 0x13, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 13), "Start typing...", 0x0E, 0xFF, 1, 0);
    m13_printf(start_pos + m13_coords_to_index(2, 190), "PRESS ESC TO EXIT. THE FILE IS TEMPORARY AND WILL NOT SAVE BETWEEN SESSIONS.", 0x0C, 0xFF, 1, 0);

    while (1) {
        scancode = kb_wait_for_scancode();
        m13_draw_window(start_pos, 320, 200, "SETTINGS", settings_img_icon, 0x0F, 0x12, 0x11, 0x13, 0);
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