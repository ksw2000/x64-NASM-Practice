# x64-NASM-Practice

My practice for Intel x86_64 NASM on Windows

## Quick start

```sh
# utf8
chcp 65001

# assemble
nasm -f win64 {filename}.asm

# link by goLink
goLink /console {filename}.obj msvcrt.dll

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

## The difference between gcc and goLink

**for gcc**

```nasm
    global main
section .data
section .bss
section .text
main:
    ; TODO
```

**for goLinker**

```nasm
section .data
section .bss
section .text
start:
    ; TODO
```

## Useful Link

+ [Appendix B: x86 Instruction Reference](https://www.csie.ntu.edu.tw/~comp03/nasm/nasmdocb.html)