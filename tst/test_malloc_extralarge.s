;label:   opcode    operands, operands      ; comment

          ; includes
          %include  "malloc.i"
          %include  "stdlib.i"

          global    _start

          section   .text
_start:   
          push      rbp
          mov       rbp, rsp
          sub       rsp, 16

          mov       rdi, 8192
          call      malloc
          mov       [rbp-8], rax

          mov       rdi, [rbp-8]
          call      free

          xor       rdi, rdi
          call      exit

          section   .data
