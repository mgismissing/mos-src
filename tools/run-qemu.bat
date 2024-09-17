@echo off

tools\build && qemu-system-x86_64 -cdrom iso\mos.iso -monitor telnet:127.0.0.1:24000,server,nowait