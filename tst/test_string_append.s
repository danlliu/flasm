;label:   opcode    operands, operands      ; comment

          ; includes
          %include  "stdio.i"
          %include  "stdlib.i"
          %include  "string.i"

          global    _start

          section   .text
_start:   lea       rdi, msg
          call      String_ctor_cstr
          mov       rdi, rax
          mov       rbx, rax
          mov       rsi, 10
          call      String_append
          mov       rdi, rbx
          call      String_get_data
          mov       rdi, rax
          call      puts

          mov       rdi, rbx
          call      String_dtor
          xor       rdi, rdi
          call      exit

          section   .data

msg:      db        "Hello, world", 0