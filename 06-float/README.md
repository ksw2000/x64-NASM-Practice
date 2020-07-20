# 浮點數運算

> 本筆記參考 2012年由松崗出版社所出版之「64 位元組合語言」 
> 
> ISBN: 978-957-22-3994-0

## 浮點堆疊

> x87 共同處理器有一個浮點堆疊，由八個浮點暫存器組成，每個浮點暫存器各有 80bits 依次命名為 ST0 \~ ST7 (Intel 命名為 R0 \~ R7)
> 
> push 時從 ST7 開始往 ST0 疊入，最頂端為 TOS
> 
> TOP 一開始是 111接著是 110 101 100 011 010 001 000 分別表示指向 ST7, 6, 5, ... , 0
> 
> 利用 FINIT 初始化堆疊，FLD 做疊入
> 
> ```nasm
> a    dq    1.5
> b    dq    3.5
> c    dq    5.5
>     finit
>     fld    qword [a]
>     fld    qword [b]
>     fld    qword [c]
> ```
> 
> 將存於記憶體的值存入暫存器叫載入 (load)
> 
> 將暫存器的值存入記憶體叫儲存(save)
> 
> ```nasm
> fld    qword [a]    ; 將浮點數 a 疊入堆疊頂端
>                     ; float + load
> fstp   qword [d]    ; 疊出頂端浮點數存入 d 變數中 
>                     ; float + save + TOS + pop 
> ```

## 狀態字組

> x87 的狀態字組可以反映出整個共同處理器的狀況

## 控制字組

> x87 的控制字組包含：例外遮蓋、插斷遮蓋及控制遮蓋等

## 標籤字組

> x87 的標籤字組包含八個標籤，每個標籤包含二個位元，分別對應到浮點堆疊中的暫存器
> 
> + 00 ：正確的值
> 
> + 01 ：0 值
> 
> + 10：特殊值、非數值、無窮大值、非正規化值
> 
> + 11：空白 ASCII 碼 32

---

> 其餘可參考 [80x86 及 80x87 暫存器](https://wanker742126.neocities.org/asm/ap02.html)

---

## x87 指令集

### FABS

> 取 TOS 值的絕對值後存回 TOS

### FADD, FADDP, FIADD

> 將指定運算元的值加入 TOS ，指令後面跟著 P 表示要將 TOS 值疊出。FIADD 將指定運算元的整數 (16 bits or 32 bits) 值加入 TOS

### FCHS

> TOS 值改變符號

### FCOM, FCOMP, FCOMPP

> TOS 與指定運算元做比較，指令後面跟兩個 P 表示要將浮點堆疊疊出兩次。比較的結果會設定浮點狀態字組中的 C0 及 C3 位元值
> 
> TOS 較小則 C0 = 1, C3 = 0
> 
> 相等則 C0 = 1, C3 = 1
> 
> TOS 較大則 C0 = 0, C3 = 0
> 
> 若 TOS 與非數值做比較則 C0 = 1, C3 = 1

### FCOS, FSIN

> 求 TOS 弧度值的 cos 及 sin，並將結果存回 TOS

### FDIV, FDIVP, FDIVPP

> 類似 FADD, FADDP, FADDPP

### FICOM, FICOMP

> TOS 與指定整數 (16bits, 32bits) 運算元比較

### FILD, FIST, FISTP

> 指令 FILD 將指定整數 (16bits, 32bits) 運算元疊入浮點堆疊頂端
> 指令 FIST 將 TOS 存入指定整數運算元
> 指令 FISTP 將 TOS 疊出至指定整數運算元

### FINIT

> 初始化浮點堆疊，堆疊頂端指標指向狀態字組裡 TOP 值為「 000 」的浮點暫存器，所有浮點暫存器內含均設為空白

### FLD

> 將指定運算元疊入浮點堆疊頂端

### FLDxx

| 指令     | 功能              |
| ------ | --------------- |
| FLD1   | 疊入常數 1          |
| FLDL2E | 疊入以 2 為底的自然對數 e |
| FLDL2T | 疊入以 2 為底的對數 10  |
| FLDLG2 | 疊入以 10 為底的對數 2  |
| FLDLN2 | 疊入以 e 為底的對數 2   |
| FLDPI  | 疊入圓周率 PI        |
| FLDZ   | 疊入常數 0          |

### FMUL, FMULP, FMULPP

> 類似 FADD, FADDP, FADDPP

### FRSTOR

> 將 FSAVE 所儲存的整個浮點堆疊環境從記憶體變數存回

### FSAVE

> 將整個浮點數環境存入記憶體變數中

### FSQRT

> 求 TOS 平方根，結果存回 TOS

### FST, FSTP

> FST 將 TOS 存入指定運算元
> 
> FSTP 將 TOS 疊出至指定運算元

### FSTCW

> 將 FPU 控制字組存入指定運算元或 AX

### FSTENV

> 將浮點環境變數值存入記憶體位址
