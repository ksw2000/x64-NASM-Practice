# 基本字串指令

| 指令    | 功能  | 說明                             |     |     |
| ----- | --- | ------------------------------ | --- | --- |
| CMPSB | 比較  | 比較來源字串與目的字串一個指定 byte           | RSI | RDI |
| CMPSW |     |                                | RSI | RDI |
| CMPSD |     |                                | RSI | RDI |
| CMPSQ |     |                                | RSI | RDI |
| LODSB | 載入  | 將來源字串(byte)載入 AL               | AL  | RSI |
| LODSW |     | word 載入 AX                     | AX  | RSI |
| LODSD |     | double word 載入 EAX             | EAX | RSI |
| LODSQ |     | quad-word 載入 RAX               | RAX | RSI |
| SCANB | 掃描  | 掃描來源字串一個指定 byte                | AL  | RSI |
| SCANW |     |                                | AX  | RSI |
| SCAND |     |                                | EAX | RSI |
| SCANQ |     |                                | RAX | RSI |
| STOSB | 儲存  | 將 AL 儲存至字串一個指定 byte 位址         | RDI | AL  |
| STOSW |     | 將 AX 儲存至字串一個指定 word 位址         | RDI | AX  |
| STOSD |     | 將 EAX 儲存至字串一個指定 double word 位址 | RDI | EAX |
| STOSQ |     | 將 RAX 儲存至字串一個指定 quad-word 位址   | RDI | RAX |
