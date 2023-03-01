;label:   opcode    operands, operands      ; comment

          ; includes
          %include  "stdio.i"
          %include  "stdlib.i"
          %include  "string.i"

          global    _start

          section   .text
_start:   lea       rdi, msg
          mov       rsi, 65
          mov       rdx, 256
          call      memset
          lea       rdi, msg
          call      puts
          xor       rdi, rdi
          call      exit

          section   .data

msg:      times 256 db 0
          db        10, 0