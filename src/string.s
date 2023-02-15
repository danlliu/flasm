;label:   opcode    operands, operands      ; comment
;
; Calling convention
; Arguments:
; rdi, rsi, rdx, r10, r8, r9, then stack if needed
; return in rax
;
; rax, rbx, rcx, r12, r13, r14, r15 caller saved
; rdx, rdi, rsx, r8,  r9,  r10, r11 callee saved

          global    strlen

          section   .text

strlen:   mov       rbx, rdi
          mov       rax, 1
.loop:    mov       rcx, [rbx]
          test      rcx, rcx
          jz        strlen.endloop
          inc       rbx
          inc       rax
          jmp       .loop
.endloop: ret