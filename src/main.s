;label:   opcode    operands, operands      ; comment

          %include "stdio.i"
          %include "stdlib.i"

          global    _start

          section   .text
_start:   mov       rdi, message
          call      puts
          xor       rdi, rdi
          call      exit

          section   .data
message:  db        "Hello, World", 10      ; note the newline at the end