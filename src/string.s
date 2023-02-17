;label:   opcode    operands, operands      ; comment
;
; Calling convention
; Arguments:
; rdi, rsi, rdx, r10, r8, r9, then stack if needed
; return in rax
;
; rbx, rsp, rbp, r12, r13, r14, r15 callee saved
; all others caller saved

; globals
          global    strlen
          global    strcpy

          section   .text

strlen:   push      rbx
          mov       rbx, rdi
          mov       rax, 1
.loop:    mov       rcx, [rbx]
          test      rcx, rcx
          jz        strlen.endloop
          inc       rbx
          inc       rax
          jmp       .loop
.endloop: pop       rbx
          ret

strcpy:   push      rbx
.loop:    mov       dl, [rsi]
          mov       [rdi], dl
          inc       rdi
          inc       rsi
          test      dl, dl
          jnz       strcpy.loop
.end:     pop       rbx
          ret
