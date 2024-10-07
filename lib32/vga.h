#define SCR_ADDRESS_START   0xB800
#define SCR_WIDTH           0xA0
#define SCR_HEIGHT          0x32
#define SCR_SIZE            0x0FA0
#define SCR_ADDRESS_END     0xD740
#define SCR_HEIGHT_MIDDLE   0x07D0

#define SCR13_ADDRESS_START 0xA0000
#define SCR13_WIDTH         0x0140
#define SCR13_HEIGHT        0x00C8
#define SCR13_SIZE          0xFA00
#define SCR13_ADDRESS_END   0xAFA00
#define SCR13_WIDTH_MIDDLE  0x00A0
#define SCR13_HEIGHT_MIDDLE 0x7D00

typedef unsigned short coords_index;

coords_index m13_coords_to_index(uint16_t x, uint16_t y);
void m13_draw_pixel(coords_index index, uint8_t color);
uint8_t m13_get_pixel_color(coords_index index);
void m13_draw_line_h(coords_index start_pos, uint16_t length, uint8_t color);
void m13_draw_line_v(coords_index start_pos, uint16_t length, uint8_t color);
void m13_draw_rect(coords_index start_pos, uint16_t width, uint16_t height, uint8_t color, uint8_t border_color);
void m13_draw_img(coords_index start_pos, uint16_t width, uint16_t height, uint8_t image[], uint8_t zoom);

void m13_putchar(coords_index start_pos, char character, uint8_t fore, uint8_t back, uint8_t zoom, uint8_t font);
void m13_printf(coords_index start_pos, char* string_pt, uint8_t fore, uint8_t back, uint8_t zoom, uint8_t font);

void m13_draw_desktop_icon(coords_index start_pos, char* name, uint16_t name_offset, uint8_t image16x16[], uint8_t text_fore, uint8_t text_back, uint8_t selection_color, uint8_t selection_border, uint8_t zoom, uint8_t font, uint8_t state);
void m13_draw_window(coords_index start_pos, uint16_t width, uint16_t height, char* title, uint8_t image8x8[], uint8_t title_fore, uint8_t title_back, uint8_t window_back, uint8_t window_border_color, uint8_t font);