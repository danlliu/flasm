;label:   opcode    operands, operands      ; comment

          ; includes
          %include  "stdio.i"
          %include  "stdlib.i"
          %include  "string.i"

          global    _start

          section   .text
_start:   lea       rdi, msg
          call      String_ctor_cstr
          mov       r12, rax
          mov       rdi, rax
          call      String_ctor_copy
          mov       r13, rax
          mov       rdi, rax
          call      String_get_data
          mov       rdi, rax
          call      puts

          mov       rdi, r12
          call      String_dtor
          mov       rdi, r13
          call      String_dtor
          xor       rdi, rdi
          call      exit

          section   .data

msg:      db        "Hello, world", 10, 0