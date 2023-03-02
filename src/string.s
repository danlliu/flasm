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
          global    memset
          global    strlen
          global    strcpy
          global    strcmp

          global    String_ctor_empty
          global    String_ctor_cstr
          global    String_ctor_copy
          global    String_assign
          global    String_dtor

          global    String_get_data
          global    String_get_size
          global    String_get_capacity

          global    String_at
          global    String_change_capacity
          global    String_append
          global    String_concat
          global    String_compare
          global    String_starts_with

          section   .text

;
; C string methods
;

memset:   
          mov       rax, rsi
          mov       ecx, edx
          rep stosb     
          ret

strlen:   mov       rsi, rdi
          mov       rcx, 0
.loop:    lodsb
          test      al, al
          jz        strlen.endloop
          inc       rcx
          jmp       .loop
.endloop: mov       rax, rcx
          ret

strcpy:   
.loop:    lodsb
          stosb
          test      al, al
          jnz       strcpy.loop
.end:     ret

strcmp:   
.loop:    lodsb
          mov       cl, [rdi]
          inc       rdi
          sub       cl, al
          jne       strcmp.ret
          test      al, al
          jnz       strcmp.loop
.ret:     movsx     rax, cl
          ret

;
; C++-style strings
;
; struct String { (16 B)
;   char* data
;   int32 size
;   int32 capacity
; }
;
; - String_ctor_empty(size)
; - String_ctor_cstr(char*)
; - String_ctor_copy(String*)
; - String_get_data
; - String_get_size
; - String_get_capacity
;

String_ctor_empty:
          ; stack frame:
          ; rbp-8:  stored size
          ; rbp-16: String* result
          push      rbp
          mov       rbp, rsp
          sub       rsp, 16
          push      rbx
          mov       [rbp-8], rdi
          mov       rdi, 16
          call      malloc
          mov       rbx, [rbp-8]
          mov       qword [rax+8], 0
          mov       [rax+12], ebx

          mov       [rbp-16], rax
          mov       rdi, [rbp-8]
          call      malloc

          mov       rbx, [rbp-16]
          mov       [rbx], rax

          mov       rdi, rax
          xor       rsi, rsi
          mov       rdx, [rbp-8]
          call      memset
          mov       rax, [rbp-16]
          pop       rbx
          leave
          ret

String_ctor_cstr:
          ; stack frame:
          ; rbp-8:  cstr_in
          ; rbp-16: String* result
          push      rbp
          mov       rbp, rsp
          sub       rsp, 16
          mov       [rbp-8], rdi
          call      strlen
          mov       rdi, rax
          call      String_ctor_empty
          mov       [rbp-16], rax
          mov       rdi, rax
          call      String_get_data
          mov       rdi, rax
          mov       rsi, [rbp-8]
          call      strcpy
          mov       rdi, [rbp-8]
          call      strlen
          mov       rdi, [rbp-16]
          mov       rsi, rax
          call      String_get_size_addr
          mov       [rax], esi
          mov       rax, [rbp-16]
          leave
          ret

String_ctor_copy:
          ; stack frame:
          ; rbp-8:  String* in
          ; rbp-16: String* result
          push      rbp
          mov       rbp, rsp
          sub       rsp, 16
          mov       [rbp-8], rdi
          call      String_get_capacity
          mov       rdi, rax
          call      String_ctor_empty
          mov       [rbp-16], rax
          mov       rdi, [rbp-8]
          call      String_get_data
          mov       [rbp-8], rax
          mov       rdi, [rbp-16]
          call      String_get_data
          mov       rdi, rax
          mov       rsi, [rbp-8]
          call      strcpy
          mov       rax, [rbp-16]
          leave
          ret

String_assign:
          ; stack frame:
          ; rbp-8: String* cur
          ; rpb-16: String* copy
          mov       rbp, rsp
          sub       rsp, 16
          mov       [rbp-8], rdi
          mov       rdi, rsi
          call      String_ctor_copy
          mov       [rbp-16], rax
          mov       rdi, [rbp-8]
          mov       rsi, [rbp-16]
          mov       rax, [rdi]
          xchg      rax, [rsi]
          mov       [rdi], rax
          mov       rax, [rdi+8]
          xchg      rax, [rsi+8]
          mov       [rdi+8], rax
          call      String_dtor
          mov       rax, [rbp-8]
          ret

String_dtor:
          ; stack frame:
          ; rbp-8: String* in
          push      rbp
          mov       rbp, rsp
          sub       rsp, 16
          mov       [rbp-8], rdi
          call      String_get_data
          mov       rdi, rax
          call      free
          mov       rdi, [rbp-8]
          call      free
          leave
          ret

; the next six functions do not modify any register except rax

String_get_data:
          mov       rax, [rdi]
          ret

String_get_data_addr:
          lea       rax, [rdi]
          ret

String_get_size:
          mov       eax, [rdi+8]
          ret

String_get_size_addr:
          lea       rax, [rdi+8]
          ret

String_get_capacity:
          mov       eax, [rdi+12]
          ret

String_get_capacity_addr:
          lea       rax, [rdi+12]
          ret



String_at:
          push      rsi
          call      String_get_data
          pop       rsi
          add       rsi, rax
          lodsb
          ret

String_change_capacity:
          ; stack frame
          ; rbp-8: String* cur
          ; rbp-16: size, then char* new
          push      rbp
          mov       rbp, rsp
          sub       rsp, 16
          mov       [rbp-8], rdi
          mov       [rbp-16], rsi
          call      String_get_capacity
          mov       rdi, [rbp-16]
          cmp       rax, rdi
          jl        .run 
          leave
          ret
.run:     call      malloc
          mov       [rbp-16], rax
          mov       rdi, [rbp-8]
          call      String_get_data
          mov       rsi, rax
          mov       rdi, [rbp-16]
          call      strcpy
          mov       rdi, [rbp-8]
          call      String_get_data_addr
          mov       rdi, [rbp-16]
          xchg      rdi, [rax]
          call      free
          leave
          ret

String_grow:
          push      rdi
          call      String_get_capacity
          pop       rdi
          mov       rsi, rax
          shl       rsi, 1
          call      String_change_capacity
          ret

String_append:
          ; stack frame
          ; rbp-8: String* cur
          ; rbp-16: char to save
          push      rbp
          mov       rbp, rsp
          sub       rsp, 16
          mov       [rbp-8], rdi
          mov       [rbp-16], rsi
          call      String_get_capacity
          mov       rcx, rax
          call      String_get_size
          inc       rax
          cmp       rax, rcx
          jle       String_append.nogrow
          call      String_grow
.nogrow:  mov       rdi, [rbp-8]
          call      String_get_data
          mov       rsi, rax
          call      String_get_size
          mov       eax, eax                 ; zero out top 32b
          mov       rcx, [rbp-16]
          mov       [rsi+rax], cl
          leave
          ret

String_concat:
          ; stack frame
          ; rbp-8: String* cur
          ; rbp-16: String* other, then char* data
          push      rbp
          mov       rbp, rsp
          sub       rsp, 16
          mov       [rbp-8], rdi
          mov       [rbp-16], rsi
          mov       rdi, rsi
          call      String_get_data
          mov       [rbp-16], rax
          call      String_get_size
          mov       esi, eax
          mov       rdi, [rbp-8]
          call      String_get_size
          add       esi, eax
          call      String_get_capacity
          cmp       esi, eax
          jle       String_append.nogrow
          call      String_change_capacity
.nogrow:  mov       rdi, [rbp-8]
          call      String_get_data
          mov       rsi, rax
          call      String_get_size
          add       rsi, rax                 ; zero out top 32b
          mov       rdi, rsi
          mov       rsi, [rbp-16]
          call      strcpy
          leave
          ret

String_compare:
          call      String_get_data
          mov       rdi, rsi
          mov       rsi, rax
          call      String_get_data
          mov       rdi, rax
          xchg      rdi, rsi
          call      strcmp
          ret

String_starts_with:
          call      String_get_data
          mov       rdi, rsi
          mov       rsi, rax
          call      String_get_data
          mov       rdi, rax
          xchg      rdi, rsi
.loop     lodsb
          test      al, al
          jz        String_starts_with.end
          mov       cl, [rdi]
          inc       rdi
          cmp       al, cl
          je        String_starts_with.loop
          mov       al, 1
.end      xor       al, 1
          movsx     rax, al
          ret

;
; String utility methods
;


