;label:   opcode    operands, operands      ; comment
;
; Calling convention
; Arguments:
; rdi, rsi, rdx, r10, r8, r9, then stack if needed
; return in rax
;
; rbx, rsp, rbp, r12, r13, r14, r15 callee saved
; all others caller saved

          %include  "string.i"

; globals
          global    puts

          section   .text

puts:     push      rbx
          call      strlen
          mov       rdx, rax
          mov       rsi, rdi
          mov       rax, 1                  ; syscall write
          mov       rdi, 1                  ; stdout
          syscall
          pop       rbx
          ret
