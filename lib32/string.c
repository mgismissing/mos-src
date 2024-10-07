#include "stdint.h"
#include "string.h"

bool strcmp(char* str1, char* str2) {
    uint16_t offset = 0;
    while (*(str1+offset) != 0) {
        if (*(str1+offset) != *(str2+offset)) {return true;}
        offset++;
    }
    return false;
}