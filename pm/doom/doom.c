#include "../../lib32/stdint.h"
#include "../../lib32/vga.h"
#include "../../lib32/stdio.h"
#include "../../lib32/timer.h"
#include "../../lib32/math.h"
#include "doom.h"

#define GAME_SCR_WIDTH  320
#define GAME_SCR_HEIGHT 200

float plr_x = 8;
float plr_y = 8;
float plr_a = 0;

int map_w = 16;
int map_h = 16;

float plr_fov = 3.14159 / 4.0;
float plr_render_distance = 16.0;

// start point when the app is launched
uint8_t doom_main() {
    // Create the map
    char map[] = {
        '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' ', ' ', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' ', ' ', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', '#', '#', '#', '#', '#', '#', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
        '#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#',
        '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#',
    };

    uint32_t tp1 = timer_get_current_ticks();
    uint32_t tp2 = timer_get_current_ticks();

    while (true) {

        tp2 = timer_get_current_ticks();
        float elapsed_time = (float)(tp2 - tp1);
        tp1 = tp2;

        if (kb_is_scancode_pressed(0x1E /* A */)) {
            plr_a -= (0.1) * elapsed_time;
        }
        if (kb_is_scancode_pressed(0x20 /* D */)) {
            plr_a += (0.1) * elapsed_time;
        }
        if (kb_is_scancode_pressed(0x11 /* W */)) {
            plr_x += math_sinf(plr_a) * 0.02 * elapsed_time;
            plr_x += math_cosf(plr_a) * 0.02 * elapsed_time;
        }
        if (kb_is_scancode_pressed(0x1F /* S */)) {
            plr_x -= math_sinf(plr_a) * 0.02 * elapsed_time;
            plr_x -= math_cosf(plr_a) * 0.02 * elapsed_time;
        }

        for (int x = 0; x < GAME_SCR_WIDTH; x++) {
            // Calculate the projected ray angle
            float ray_a = (plr_a - plr_fov / 2.0) + ((float)x / (float)GAME_SCR_WIDTH) * plr_fov;

            float ray_distance_to_wall = 0;
            bool ray_hit_wall = false;

            float plr_eye_x = math_sinf(ray_a);
            float plr_eye_y = math_cosf(ray_a);

            while (!ray_hit_wall && ray_distance_to_wall < plr_render_distance) {
                ray_distance_to_wall += 0.1;

                int ray_test_x = (int)(plr_x + plr_eye_x * ray_distance_to_wall);
                int ray_test_y = (int)(plr_y + plr_eye_y * ray_distance_to_wall);

                // Test if ray is out of bounds
                if (ray_test_x < 0 || ray_test_x >= map_w || ray_test_y < 0 || ray_test_y >= map_h) {
                    ray_hit_wall = true;
                    ray_distance_to_wall = plr_render_distance;
                } else {
                    // Is the cell a wall?
                    if (map[ray_test_y * map_w + ray_test_x] == '#') {
                        ray_hit_wall = true;
                    }
                }
            }

            // Calculate distance to ceiling and floor
            int map_ceiling = (float)(GAME_SCR_HEIGHT / 2.0) - GAME_SCR_HEIGHT / ((float)ray_distance_to_wall);
            int map_floor = GAME_SCR_HEIGHT - map_ceiling;

            uint8_t shade = 0x10;

            if (ray_distance_to_wall <= plr_render_distance / 4) {shade = 0x1F;}
            else if (ray_distance_to_wall <= plr_render_distance / 3) {shade = 0x1D;}
            else if (ray_distance_to_wall <= plr_render_distance / 2) {shade = 0x1B;}
            else if (ray_distance_to_wall <= plr_render_distance / 1) {shade = 0x19;}
            else {shade = 0x10;}

            for (int y = 0; y < GAME_SCR_HEIGHT; y++) {
                if (y < map_ceiling) {
                    m13_draw_pixel(y * GAME_SCR_WIDTH + x, 0x10);
                } else if (y > map_ceiling && y <= map_floor) {
                    m13_draw_pixel(y * GAME_SCR_WIDTH + x, shade);
                } else {
                    uint8_t floor_shade = 0x10;
                    float brightness = 1.0 - (((float)y - GAME_SCR_HEIGHT / 2) / ((float)GAME_SCR_HEIGHT / 2));
                    if (brightness <= 0.25) {floor_shade = 0x18;}
                    else if (brightness <= 0.5) {floor_shade = 0x16;}
                    else if (brightness <= 0.75) {floor_shade = 0x14;}
                    else if (brightness <= 0.9) {floor_shade = 0x12;}
                    else {floor_shade = 0x10;}
                    m13_draw_pixel(y * GAME_SCR_WIDTH + x, floor_shade);
                }
            }
        }
    }
    return 0;
}