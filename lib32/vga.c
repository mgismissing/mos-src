#include "stdint.h"
#include "vga.h"

coords_index m13_coords_to_index(uint16_t x, uint16_t y) {
    return y * SCR13_WIDTH + x;
}

void m13_draw_pixel(coords_index index, uint8_t color) {
    *(uint8_t*)(SCR13_ADDRESS_START+index) = color;
    return;
}

uint8_t m13_get_pixel_color(coords_index index) {
    return *(uint8_t*)(SCR13_ADDRESS_START+index);
}

void m13_draw_line_h(coords_index start_pos, uint16_t length, uint8_t color) {
    for (coords_index pos = 0; pos < length; pos++) {
        m13_draw_pixel(pos+start_pos, color);
    }
    return;
}

void m13_draw_line_v(coords_index start_pos, uint16_t length, uint8_t color) {
    for (coords_index pos = 0; pos < length; pos++) {
        m13_draw_pixel(pos*SCR13_WIDTH+start_pos, color);
    }
    return;
}

void m13_draw_rect(coords_index start_pos, uint16_t width, uint16_t height, uint8_t color, uint8_t border_color) {
    for (uint16_t y = 0; y < height; y++) {
        if (y == 0 || y == height-1) {
            m13_draw_line_h(y*SCR13_WIDTH+start_pos, width, border_color);
        } else {
            m13_draw_line_h(y*SCR13_WIDTH+start_pos, width, color);
        }
        m13_draw_pixel(y*SCR13_WIDTH+start_pos, border_color);
        m13_draw_pixel(y*SCR13_WIDTH+start_pos+width-1, border_color);
    }
    return;
}

void m13_draw_img(coords_index start_pos, uint16_t width, uint16_t height, uint8_t image[], uint8_t zoom) {
    for (uint16_t y = 0; y < height; y++) {
        for (uint16_t x = 0; x < width; x++) {
            if (image[(y * width) + x] != 0xFF) {
                m13_draw_rect(start_pos + m13_coords_to_index(x * zoom, y * zoom), zoom, zoom, image[(y * width) + x], image[(y * width) + x]);
            }
        }
    }
    return;
}

extern uint32_t scr13_font0_start;
extern uint32_t scr13_font1_start;

void m13_putchar(coords_index start_pos, char character, uint8_t fore, uint8_t back, uint8_t zoom, uint8_t font) {
    uint32_t* current_font;
    if (font == 0) {
        current_font = (uint32_t*) ((uint32_t) &scr13_font0_start) + ((character - ' ') * 1);
    } else if (font == 1) {
        current_font = (uint32_t*) ((uint32_t) &scr13_font1_start) + ((character - ' ') * 1);
    } else {
        return;
    }

    uint16_t curr_pos = 0;
    for (int byte = 0; byte < 4; byte++) {
        uint8_t current_byte = (*current_font) >> (byte * 8) & 0xFF;
        // Iterate through each bit in the current byte
        for (uint8_t bit = 0; bit < 8; bit++) {
            // Draw the pixel
            if ((((current_byte >> (7 - bit)) & 1) == 1) && (fore != 0xFF)) {
                m13_draw_rect(start_pos + curr_pos, zoom, zoom, fore, fore);
            } else if (back != 0xFF) {
                m13_draw_rect(start_pos + curr_pos, zoom, zoom, back, back);
            }
            curr_pos += zoom;
            if (bit == 3) {
                curr_pos += (SCR13_WIDTH * zoom) - (4 * zoom);
            }
            if (bit == 7) {
                curr_pos += (SCR13_WIDTH * zoom) - (4 * zoom);
            }
        }
    }
}

void m13_printf(coords_index start_pos, char* string_pt, uint8_t fore, uint8_t back, uint8_t zoom, uint8_t font) {
    uint16_t offset = 0;
    uint16_t pos = 0;
    while (*(string_pt+offset) != 0) {
        if (*(string_pt+offset) == '\n') {
            pos += SCR13_WIDTH * 8;
        } else if (*(string_pt+offset) == '\r') {
            pos -= (pos % SCR13_WIDTH);
        } else {
            m13_putchar(start_pos + (pos * zoom), *(string_pt+offset), fore, back, zoom, font);
            pos += 4;
        }
        offset++;
    }
}

void m13_draw_desktop_icon(coords_index start_pos, char* name, uint16_t name_offset, uint8_t image16x16[], uint8_t text_fore, uint8_t text_back, uint8_t selection_color, uint8_t selection_border, uint8_t zoom, uint8_t font, uint8_t state) {
    if (state == 1) {
        m13_draw_rect(start_pos, 40, 42, selection_color, selection_border);
    }
    m13_draw_img(start_pos + m13_coords_to_index(12, 4), 16, 16, image16x16, zoom);
    m13_printf(start_pos + m13_coords_to_index(4, 22) + name_offset, name, text_fore, text_back, zoom, font);
    return;
}

void m13_draw_window(coords_index start_pos, uint16_t width, uint16_t height, char* title, uint8_t image8x8[], uint8_t title_fore, uint8_t title_back, uint8_t window_back, uint8_t window_border_color, uint8_t font) {
    m13_draw_rect(start_pos, width, height, window_back, window_border_color);
    m13_draw_rect(start_pos, width, 12, title_back, window_border_color);
    m13_printf(start_pos + m13_coords_to_index(12, 2), title, title_fore, title_back, 1, font);
    return;
}