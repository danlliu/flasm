;label:   opcode    operands, operands      ; comment

          ; includes
          %include  "stdio.i"
          %include  "stdlib.i"
          %include  "string.i"

          global    _start

          section   .text
_start:   
          mov       rdi, 0
          call      String_from_int

          mov       r12, rax
          mov       rdi, rax
          call      String_get_data

          mov       rdi, rax
          call      puts

          lea       rdi, newline
          call      puts

          mov       rdi, r12
          call      String_dtor

          xor       rdi, rdi
          call      exit

          section   .data

newline:  db        10, 0
