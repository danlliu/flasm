;label:   opcode    operands, operands      ; comment

          ; includes

          %include  "stdio.i"
          %include  "stdlib.i"
          %include  "string.i"

          global    _start

          section   .text
_start:   
          lea       rdi, msg1
          lea       rsi, msg2
          call      strcpy
          lea       rdi, msg1
          call      puts
          xor       rdi, rdi
          call      exit

          section   .data

msg1:     db        "aaaaaaaaaaaaa", 10, 0
msg2:     db        "Jello, world!", 10, 0
