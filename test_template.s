;label:   opcode    operands, operands      ; comment

          ; includes
          %include  "stdlib.i"

          global    _start

          section   .text
_start:   
          xor       rdi, rdi
          call      exit

          section   .data
