#include "../../lib32/stdint.h"
#include "../../lib32/vga.h"
#include "../../lib32/stdio.h"
#include "../../lib32/timer.h"
#include "../../lib32/math.h"
#include "doom.h"

#define SW         320
#define SH         200
#define SW2        (SW/2)                   //half of screen width
#define SH2        (SH/2)                   //half of screen height

typedef struct {
int fr1, fr2;          //frame 1 frame 2, to create constant frame rate
} time; time T;

typedef struct {
int w, s, a, d;        //move up, down, left, right
int sl, sr;            //strafe left, right
int m;                 //move up, down, look up, down
} keys; keys K;


void pixel(int x, int y, int c) {
    uint8_t color;
    if(c==0){color = 0x2C;} //Yellow
    if(c==1){color = 0x74;} //Yellow darker
    if(c==2){color = 0x30;} //Green
    if(c==3){color = 0x78;} //Green darker
    if(c==4){color = 0x34;} //Cyan
    if(c==5){color = 0x7C;} //Cyan darker
    if(c==6){color = 0x72;} //brown
    if(c==7){color = 0xBA;} //brown darker
    if(c==8){color = 0x7F;} //background
    m13_draw_pixel(m13_coords_to_index(x, y), color);
}

void movePlayer() {
//move up, down, left, right
    if(K.a ==1 && K.m==0){}
    if(K.d ==1 && K.m==0){}
    if(K.w ==1 && K.m==0){}
    if(K.s ==1 && K.m==0){}
    //strafe left, right
    if(K.sr==1){}
    if(K.sl==1){}
    //move up, down, look up, look down
    if(K.a==1 && K.m==1){}
    if(K.d==1 && K.m==1){}
    if(K.w==1 && K.m==1){}
    if(K.s==1 && K.m==1){}
}

void clearBackground() {
    int x, y;
    for(y=0; y < SH; y++) { 
        for(x=0; x < SW; x++){
            pixel(x, y, 8);
        }
    }
}

int tick;
void draw3D() {
    int x, y, c=0;
    for(y=0; y < SH2; y++) {
        for(x=0; x < SW2; x++) {
            pixel(x, y, c); 
            c+=1;
            if (c > 8) {
                c = 0;
            }
        }
    }
    //frame rate
    tick+=1;
    if (tick > 20) {
        tick=0;
    }
    pixel(SW2, SH2+tick, 0);
}

void display() {
    uint32_t old_elapsed_time = timer_get_current_ticks();
    int x, y;
    if (T.fr1 - T.fr2 >= 50) {
        clearBackground();
        movePlayer();
        draw3D();

        T.fr2 = T.fr1;
        //glutSwapBuffers();
    }

    T.fr1 = timer_get_current_ticks() - old_elapsed_time;
}

void keysDown(uint8_t key) {
    if(key=='w') { K.w =1;}
    if(key=='s') { K.s =1;}
    if(key=='a') { K.a =1;}
    if(key=='d') { K.d =1;}
    if(key=='m') { K.m =1;}
    if(key==',') { K.sr=1;}
    if(key=='.') { K.sl=1;}
    return;
}

void keysUp(uint8_t key) {
    if(key=='w') { K.w =0;}
    if(key=='s') { K.s =0;}
    if(key=='a') { K.a =0;}
    if(key=='d') { K.d =0;}
    if(key=='m') { K.m =0;}
    if(key==',') { K.sr=0;}
    if(key=='.') { K.sl=0;}
    return;
}

void init() {
    return;
}



// start point when the app is launched
uint8_t doom_main() {
    init();
    return 0;
    while (true) {
        display();
        break;
        if (kb_get_last_scancode_press_state() == 0) {
            keysUp(kb_get_last_scancode());
        } else {
            keysDown(kb_get_last_scancode());
        }
    }
    return 0;
}