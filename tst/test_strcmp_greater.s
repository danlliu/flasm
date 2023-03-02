;label:   opcode    operands, operands      ; comment

          ; includes
          %include  "stdio.i"
          %include  "stdlib.i"
          %include  "string.i"

          global    _start

          section   .text
_start:   

          lea       rdi, msg1
          lea       rsi, msg2
          call      strcmp

          test      rax, rax
          jle       _start.fail

          lea       rdi, correct
          call      puts

.fail:    nop

          xor       rdi, rdi
          call      exit

          section   .data

msg1:     db        "Jello, world", 0
msg2:     db        "Hello, world", 0
correct:  db        "Correct", 10, 0
