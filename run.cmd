@echo off
chcp 65001
nasm -f win64 "%1.asm" -o "%1.obj"
golink /console %1.obj msvcrt.dll
echo -----------------------------------------------------
"%1.exe"