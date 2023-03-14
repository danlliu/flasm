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

          mov       rdi, 24
          call      malloc
          mov       [rbp-8], rax

          mov       rax, [rax-8]            ; ok yes i'm accessing internals
          sub       rax, 32
          push      rax

          mov       rdi, [rbp-8]
          call      free

          pop       rdi
          call      exit

          section   .data
