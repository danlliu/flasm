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

          lea       rdi, message
          call      strlen

          mov       rdi, [rbp-8]
          lea       rsi, message
          mov       rdx, rax
          xor       r10, r10
          call      send

          mov       rdi, [rbp-24]
          mov       rsi, SHUTDOWN_ALL
          call      shutdown

          mov       rdi, [rbp-24]
          mov       rsi, SHUTDOWN_ALL
          call      shutdown

          xor       rdi, rdi
          call      exit

          section   .data
message:  db        "HTTP/1.1 200 OK", 13, 10
          db        "Content-Type: text/plain", 13, 10
          db        "Content-Length: 15", 13, 10, 13, 10
          db        "Hello from x86!", 13, 10
          db        0