;label:   opcode    operands, operands      ; comment
;
; socket.i: socket interface
; 
; methods:
;  - socket (rdi = family, rsi = type, rdx = protocol)
;  - sockaddr_in (rdi = uint16 port, esi = uint32 addr): returns malloc'd pointer
;  - bind (rdi = sockfd, rsi = sockaddr_in*)
;  - listen (rdi = sockfd, rsi = backlog)
;  - accept (rdi = sockfd, rsi = sockaddr_in* addr)
;  - send (rdi = sockfd, rsi = char* buf, rdx = uint64 len, r10 = uint64 flags)
;  - shutdown (rdi = sockfd, rsi = int how)
;
; macros:
;  - AF_INET: IPv4 (= 0x2)
;  - AF_INET6: IPv6 (= 0x10)
;  - SOCK_STREAM: TCP (= 0x1)
;  - SOCK_DGRAM: UDP (= 0x2)
;  - LOCALHOST: 127.0.0.1, byte order reversed
;

          extern    socket
          extern    sockaddr_in
          extern    bind
          extern    listen
          extern    accept
          extern    send
          extern    shutdown

%define   AF_INET       0x2
%define   AF_INET6      0x10
%define   SOCK_STREAM   0x1
%define   SOCK_DGRAM    0x2
%define   LOCALHOST     0x0100007F
%define   LOCALHOST_PUB 0x00000000
%define   SHUTDOWN_ALL  2
