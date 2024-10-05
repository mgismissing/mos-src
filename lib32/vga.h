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
void m13_draw_line_h(coords_index start_pos, uint16_t length, uint8_t color);
void m13_draw_line_v(coords_index start_pos, uint16_t length, uint8_t color);
void m13_draw_rect(coords_index start_pos, uint16_t width, uint16_t height, uint8_t color);

void m13_printf(coords_index start_pos, char *string, uint8_t color);