;label:   opcode    operands, operands      ; comment

          %include "malloc.i"
          %include "socket.i"
          %include "stdio.i"
          %include "stdlib.i"
          %include "string.i"

          global    _start

          section   .text
_start:   
          push      rbp
          mov       rbp, rsp
          sub       rsp, 24
          mov       rdi, AF_INET
          mov       rsi, SOCK_STREAM
          xor       rdx, rdx
          call      socket
          mov       [rbp-24], rax
          mov       rdi, 0x401f              ; 8000, big endian 2B
          mov       esi, LOCALHOST_PUB
          call      sockaddr_in
          mov       [rbp-16], rax
          mov       rdi, [rbp-24]
          mov       rsi, rax
          call      bind
          mov       rdi, [rbp-24]
          mov       rsi, 10
          call      listen
          call      sockaddr_in
          mov       rdi, [rbp-24]
          mov       rsi, rax
          call      accept
          mov       [rbp-8], rax

          mov       rdi, rax
          lea       rsi, message
          mov       rdx, 13
          xor       r10, r10
          call      send

          xor       rdi, rdi
          call      exit

          section   .data
message:  db        "Hello, World", 10, 0