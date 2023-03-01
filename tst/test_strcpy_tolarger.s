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

msg1:     db        "large buffer with a lot of room", 10, 0
msg2:     db        34, "Small", 34, " message :", 41, 10, 0
