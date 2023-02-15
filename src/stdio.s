;label:   opcode    operands, operands      ; comment
;
; Calling convention
; Arguments:
; rdi, rsi, rdx, r10, r8, r9, then stack if needed
; return in rax
;
; rax, rbx, rcx, r12, r13, r14, r15 caller saved
; rdx, rdi, rsx, r8,  r9,  r10, r11 callee saved

          %include  "string.i"

          global    puts

          section   .text

puts:     call      strlen
          mov       rdx, rax
          mov       rsi, rdi
          mov       rax, 1                  ; syscall write
          mov       rdi, 1                  ; stdout
          syscall
          ret
