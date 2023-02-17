;label:   opcode    operands, operands      ; comment
;
; Calling convention
; Arguments:
; rdi, rsi, rdx, r10, r8, r9, then stack if needed
; return in rax
;
; rbx, rsp, rbp, r12, r13, r14, r15 callee saved
; all others caller saved

          %include  "malloc.i"

; globals

          global    socket
          global    sockaddr_in
          global    bind
          global    listen
          global    accept
          global    send

%define   AF_INET       0x2

          section   .text

socket:   push      rbx
          mov       rax, 41                 ; syscall socket
          syscall
          pop       rbx
          ret

sockaddr_in:
          push      rdi
          push      rsi
          mov       rdi, 16
          call      malloc
          pop       rsi
          pop       rdx
          mov       word [rax], AF_INET
          mov       [rax + 2], dx
          mov       [rax + 4], esi
          xor       rsi, rsi
          mov       [rax + 8], rsi
          ret

bind:     push      rbx
          mov       rax, 49                 ; syscall bind
          mov       rdx, 16
          syscall
          pop       rbx
          ret

listen:   push      rbx
          mov       rax, 50                 ; syscall listen
          syscall
          pop       rbx
          ret

accept:   push      rbp
          mov       rbp, rsp
          sub       rsp, 8
          push      rbx
          lea       rdx, [rbp-8]
          mov       rax, 43                 ; syscall accept
          syscall
          pop       rbx
          leave
          ret

send:     push      rbx
          mov       r8, 0
          mov       r9, 0
          mov       rax, 44                 ; syscall sendto
          syscall
          pop       rbx
          ret
