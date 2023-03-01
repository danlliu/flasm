;label:   opcode    operands, operands      ; comment

          ; includes

          %include  "stdio.i"
          %include  "stdlib.i"

          global    _start

          section   .text
_start:   lea       rdi, hello
          call      puts
          xor       rdi, rdi
          call      exit

          section   .data

hello:    db        "Hello, world!", 10, 0
