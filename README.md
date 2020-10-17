# x64-Nasm-Practice

>
> My practice for x64 Nasm under windows
>
> Assembler: `nasm`
>
> Linker: `GoLink`
>

## Quick start

encoding utf8

```sh
chcp 65001
```

__.asm to .obj__
```sh
nasm -f win64 {filename}.asm
```

__.obj to .exe__
```sh
goLink /console {filename}.obj msvcrt.dll
```

## Quick start by run.exe

Use `run.exe` (change encoding + assembling + linking)

```sh
run.exe {filename}
```

---

## Use GCC Linker instead

encoding utf8

```sh
chcp 65001
```

__Assembler__
```sh
nasm -f win64 {filename}.asm
```

__Linker__
```sh
gcc {filename.obj} -o filename.exe
```

Example code

```Nasm

```
