# How to use clib function in NASM on Windows

Reference: [https://en.wikipedia.org/wiki/X86_calling_conventions#Microsoft_x64_calling_convention](https://en.wikipedia.org/wiki/X86_calling_conventions#Microsoft_x64_calling_convention)

The Microsoft x64 calling convention is followed on Windows and pre-boot UEFI (for long mode on x86-64). The first four arguments are placed onto the registers. That means `RCX`, `RDX`, `R8`, `R9` for integer, struct or pointer arguments (in that order), and `XMM0`, `XMM1`, `XMM2`, `XMM3` for floating point arguments.

Additional arguments are pushed onto the stack (**right to left**). Integer return values (similar to x86) are returned in `RAX` if 64 bits or less. Floating point return values are returned in `XMM0`. Parameters less than 64 bits long are **not zero extended**; the high bits are not zeroed.

+ The registers `RAX`, `RCX`, `RDX`, `R8`, `R9`, `R10`, `R11` are considered volatile (caller-saved).
+ The registers `RBX`, `RBP`, `RDI`, `RSI`, `RSP`, `R12`, `R13`, `R14`, and `R15` are considered nonvolatile (callee-saved).

