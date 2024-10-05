#include "stdint.h"
#include "vga.h"

coords_index m13_coords_to_index(uint16_t x, uint16_t y) {
    return y * SCR13_WIDTH + x;
}

void m13_draw_pixel(coords_index index, uint8_t color) {
    *(int16_t*)(SCR13_ADDRESS_START+index) = color;
    return;
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

void m13_draw_rect(coords_index start_pos, uint16_t width, uint16_t height, uint8_t color) {
    for (uint16_t y = 0; y < height; y++) {
        m13_draw_line_h(y*SCR13_WIDTH+start_pos, width, color);
    }
    return;
}

void m13_printf(coords_index start_pos, char *string, uint8_t color) {
    return;
}