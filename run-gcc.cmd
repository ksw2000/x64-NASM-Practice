@echo off
chcp 65001
nasm -f win64 "%1.asm" -o "%1.obj"
gcc %1.obj -o %1.exe
echo -----------------------------------------------------
"%1.exe"