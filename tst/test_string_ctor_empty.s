;label:   opcode    operands, operands      ; comment

          ; includes
          %include  "stdio.i"
          %include  "stdlib.i"
          %include  "string.i"

          global    _start

          section   .text
_start:   mov       rdi, 16
          call      String_ctor_empty
          mov       rdi, rax
          mov       r12, rax
          call      String_get_data
          mov       rbx, rax
          mov       rdi, rbx
          lea       rsi, msg
          call      strcpy
          mov       rdi, rbx
          call      puts

          mov       rdi, r12
          call      String_dtor
          xor       rdi, rdi
          call      exit

          section   .data

msg:      db        "Hello, world", 10, 0
