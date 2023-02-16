;label:   opcode    operands, operands      ; comment

          %include "malloc.i"
          %include "stdio.i"
          %include "stdlib.i"

          global    _start

          section   .text
_start:   
          mov       rdi, 14
          call      malloc
          mov       byte [rax+0x0], 72
          mov       byte [rax+0x1], 101
          mov       byte [rax+0x2], 108
          mov       byte [rax+0x3], 108
          mov       byte [rax+0x4], 111
          mov       byte [rax+0x5], 44
          mov       byte [rax+0x6], 32
          mov       byte [rax+0x7], 87
          mov       byte [rax+0x8], 111
          mov       byte [rax+0x9], 114
          mov       byte [rax+0xa], 108
          mov       byte [rax+0xb], 100
          mov       byte [rax+0xc], 10
          mov       byte [rax+0xd], 0
          mov       rdi, rax
          call      puts
          xor       rdi, rdi
          call      exit

          section   .data
message:  db        "Hello, World", 10      ; note the newline at the end