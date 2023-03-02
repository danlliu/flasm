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
          lea       rdi, prefix
          call      String_ctor_cstr
          mov       r13, rax

          mov       rdi, r12
          mov       rsi, r13
          call      String_starts_with

          cmp       rax, 1
          jne       _start.fail

          lea       rdi, correct
          call      puts
.fail:    

          mov       rdi, r12
          call      String_dtor
          mov       rdi, r13
          call      String_dtor
          xor       rdi, rdi
          call      exit

          section   .data

msg:      db        "Hello, world", 0
prefix:   db        "Hello", 0
correct:  db        "Correct", 10, 0
