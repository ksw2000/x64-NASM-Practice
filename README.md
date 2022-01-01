# x64-NASM-Practice

My practice and notes for Intel x86_64 NASM on Windows.

## Quick start

```sh
# setting UTF-8 encoding
chcp 65001

# assemble
nasm -f win64 {filename}.asm

# link by goLink
goLink /console {filename}.obj /entry main msvcrt.dll

# or by gcc
gcc {filename}.obj -o {output}.exe
```

**or use batch file**

```sh
# link by goLink
./run.cmd {filename_without_extension}

# link by gcc
./run-gcc.cmd {filename_without_extension}
```

1. Download assembler - [NASM](https://www.nasm.us/)
2. Download linker - [GCC](https://osdn.net/projects/mingw/) or [GoLink](http://s.walters.free.fr/Esial/ECGo/GoAsm/Help/GoLink.htm)
3. You can download nasm.exe and GoLink.exe is in [/tools](https://github.com/liao2000/x64-NASM-Practice/tree/master/tools) instead.
4. UTF8 encoding problem [See on stackoverflow](https://stackoverflow.com/questions/57131654/using-utf-8-encoding-chcp-65001-in-command-prompt-windows-powershell-window)

## Useful Links
+ [NASM Tutorial](https://cs.lmu.edu/~ray/notes/nasmtutorial/)
+ [Appendix B: x86 Instruction Reference](https://www.csie.ntu.edu.tw/~comp03/nasm/nasmdocb.html)
+ [x86 and amd64 instruction reference](https://www.felixcloutier.com/x86/index.html)