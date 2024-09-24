extern "C" void main() {
    *(char*) 0xB8000 = 'H';
    return;
}