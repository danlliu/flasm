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

          lea       rdi, msg2
          call      String_ctor_cstr
          mov       r13, rax

          mov       rdi, r12
          mov       rsi, r13
          call      String_concat

          mov       rdi, r12
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

msg:      db        "Hello", 0
msg2:     db        " world", 10, 0