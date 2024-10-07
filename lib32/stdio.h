#define IO_PIT_PORT_DATA_CH_0   0x40
#define IO_PIT_PORT_DATA_CH_1   0x41
#define IO_PIT_PORT_DATA_CH_2   0x42
#define IO_PIT_PORT_CMD         0x43

#define IO_KB_PORT_STATUS       0x60
#define IO_KB_PORT_DATA         0x61

#define IO_KB_SCANCODE_ESC          0x01
#define IO_KB_SCANCODE_CTRL_L       0x1D
#define IO_KB_SCANCODE_SHIFT_L      0x2A
#define IO_KB_SCANCODE_ALT          0x38
#define IO_KB_SCANCODE_LOCK_CAPS    0x3A
#define IO_KB_SCANCODE_F1           0x3B
#define IO_KB_SCANCODE_F2           0x3C
#define IO_KB_SCANCODE_F3           0x3D
#define IO_KB_SCANCODE_F4           0x3E
#define IO_KB_SCANCODE_F5           0x3F
#define IO_KB_SCANCODE_F6           0x40
#define IO_KB_SCANCODE_F7           0x41
#define IO_KB_SCANCODE_F8           0x42
#define IO_KB_SCANCODE_F9           0x43
#define IO_KB_SCANCODE_F10          0x44
#define IO_KB_SCANCODE_F11          0x57
#define IO_KB_SCANCODE_F12          0x58

#define IO_KB_CHAR_UNKNOWN          0xFFFF - 0x00
#define IO_KB_CHAR_ESC              0xFFFF - 0x01
#define IO_KB_CHAR_CTRL_L           0xFFFF - 0x02
#define IO_KB_CHAR_SHIFT_L          0xFFFF - 0x03
#define IO_KB_CHAR_SHIFT_R          0xFFFF - 0x04
#define IO_KB_CHAR_ALT              0xFFFF - 0x05
#define IO_KB_CHAR_F1               0xFFFF - 0x06
#define IO_KB_CHAR_F2               0xFFFF - 0x07
#define IO_KB_CHAR_F3               0xFFFF - 0x08
#define IO_KB_CHAR_F4               0xFFFF - 0x09
#define IO_KB_CHAR_F5               0xFFFF - 0x0A
#define IO_KB_CHAR_F6               0xFFFF - 0x0B
#define IO_KB_CHAR_F7               0xFFFF - 0x0C
#define IO_KB_CHAR_F8               0xFFFF - 0x0D
#define IO_KB_CHAR_F9               0xFFFF - 0x0E
#define IO_KB_CHAR_F10              0xFFFF - 0x0F
#define IO_KB_CHAR_F11              0xFFFF - 0x10
#define IO_KB_CHAR_F12              0xFFFF - 0x11
#define IO_KB_CHAR_LOCK_SCROLL      0xFFFF - 0x12
#define IO_KB_CHAR_HOME             0xFFFF - 0x13
#define IO_KB_CHAR_ARROW_UP         0xFFFF - 0x14
#define IO_KB_CHAR_ARROW_LEFT       0xFFFF - 0x15
#define IO_KB_CHAR_ARROW_RIGHT      0xFFFF - 0x16
#define IO_KB_CHAR_ARROW_DOWN       0xFFFF - 0x17
#define IO_KB_CHAR_PAGE_UP          0xFFFF - 0x18
#define IO_KB_CHAR_PAGE_DOWN        0xFFFF - 0x19
#define IO_KB_CHAR_END              0xFFFF - 0x1A
#define IO_KB_CHAR_INSERT           0xFFFF - 0x1B
#define IO_KB_CHAR_DELETE           0xFFFF - 0x1C
#define IO_KB_CHAR_LOCK_CAPS        0xFFFF - 0x1D
#define IO_KB_CHAR_NONE             0xFFFF - 0x1E
#define IO_KB_CHAR_ALT_GR           0xFFFF - 0x1F
#define IO_KB_CHAR_LOCK_NUM         0xFFFF - 0x20

struct InterruptRegisters {
    uint32_t cr2;
    uint32_t ds;
    uint32_t edi, esi, ebp, esp, ebx, edx, ecx, eax;
    uint32_t int_no, err_code;
    uint32_t eip, csm, eflags, useresp, ss;
};

void port_out(uint16_t port, uint8_t value);
uint8_t port_in(uint16_t port);

void *memset(void *dest, char val, uint32_t count);

uint16_t kb_scancode_to_char(uint8_t scancode, bool caps);

bool kb_is_scancode_pressed(uint8_t scancode);

uint8_t kb_get_last_scancode();
uint8_t kb_get_last_scancode_press_state();
bool kb_get_caps_state();

uint8_t kb_wait_for_scancode();

void kb_clear_scancodes_press_states();

void kb_handler(struct InterruptRegisters *regs);
void kb_init();

void snd_play_tone(uint16_t tone, uint16_t duration_ms);