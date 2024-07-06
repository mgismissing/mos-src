@echo off

tools\build && qemu-system-x86_64 -cdrom iso\mos.iso && vboxmanage startvm MagnesiumOS