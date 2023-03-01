;label:   opcode    operands, operands      ; comment

          ; includes
          %include  "stdio.i"
          %include  "stdlib.i"
          %include  "string.i"

          global    _start

          section   .text
_start:   lea       rdi, msg
          mov       rsi, 65
          mov       rdx, 8
          call      memset
          lea       rdi, msg
          call      puts
          xor       rdi, rdi
          call      exit

          section   .data

msg:      db        "smolbuff", 10, 0
