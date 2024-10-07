#include "stdint.h"
#include "math.h"

float math_power(float base, int exp) {
    if(exp < 0) {
        if(base == 0)
            return -1; // Error!!
        return 1 / (base * math_power(base, (-exp) - 1));
    }
    if(exp == 0)
        return 1;
    if(exp == 1)
        return base;
    return base * math_power(base, exp - 1);
}

float math_fact(int n) {
    return n <= 0 ? 1 : n * math_fact(n-1);
}

float math_sin(int deg) {
    deg %= 360; // make it less than 360
    float rad = deg * PI / 180;
    float sin = 0;

    int i;
    for(i = 0; i < TERMS; i++) { // That's Taylor series!!
        sin += math_power(-1, i) * math_power(rad, 2 * i + 1) / math_fact(2 * i + 1);
    }
    return sin;
}

float math_cos(int deg) {
    deg %= 360; // make it less than 360
    float rad = deg * PI / 180;
    float cos = 0;

    int i;
    for(i = 0; i < TERMS; i++) { // That's also Taylor series!!
        cos += math_power(-1, i) * math_power(rad, 2 * i) / math_fact(2 * i);
    }
    return cos;
}