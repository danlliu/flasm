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

          global    malloc
          global    free

          section   .text

; malloc algorithm:
;
; malloc utilizes the buddy algorithm for allocating memory
; malloc can allocate memory in blocks of 2^k - 8 bytes, from k = 5 (24B) to
;  k = 12 (4088B)
; if malloc requires more heap space, it utilizes the `mmap` system call to
;  allocate additional memory in 4096B chunks
; malloc reserves the first 8 bytes of each allocated block for overhead;
;  the address returned by malloc is 8 bytes past the beginning of the internal
;  block
; bytes 0 - 7: next page pointer. 0x0 if no next block exists. Undefined if
; the block is allocated.
;
; Non-allocated blocks:
; - first 8 bytes: next pointer. 0x0 if no next block.
;
; Allocated blocks:
; - first 8 bytes: size of block; remaining bytes taken up by user data.
;
; to allocate n user bytes:
; take a = n + 8; find (-a & a) << 1 = z = size of block to allocate
; s = 2^5; i = 0
; while s < z or chunktbl[i] == 0x0 {
;   if (s == 2^12 and chunktbl[i] == 0x0) {
;     // allocate more memory
;     // PROT_RWX = 0x1 | 0x2 | 0x4
;     // MAP_PRIVATE|MAP_ANONYMOUS = 0x02 | 0x20
;     p = mmap(NULL, 4096, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
;     chunktbl[i] = p
;     break
;   }
;   s <<= 1; ++i;
; }
; // splitting procedure
; while s > z {
;   p = chunktbl[i]
;   chunktbl[i] = chunktbl[i]->next
;   // split chunk
;   s >>= 1
;   dec i
;   // chunk 2: p + s
;   (p + s)->next = chunktbl[i]
;   // chunktbl[i] = (p + s)->next
;   // chunk 1: p
;   p->next = p + s
;   chunktbl[i] = p
; }
; p = chunktbl[i]
; chunktbl[i] = chunktbl[i]->next
; p->next = 0x1
; return p + 8
;

malloc:   
          mov       rax, rdi
          cmp       rax, 4088
          jle       malloc.z
          push      rdi
          mov       rax, 9                  ; syscall mmap
          mov       rsi, rdi
          add       rsi, 8
          mov       rdi, 0
          mov       rdx, 7
          mov       r10, 0x22
          mov       r8, -1
          mov       r9, 0
          syscall
          pop       rsi
          add       rsi, 8
          mov       [rax], rsi
          add       rax, 8
          ret
.z:       push      rbx
          push      r12
          push      r13
          add       rax, 8
          cmp       rax, 32
          jge       malloc.rndup
          mov       rax, 32
          jmp       malloc.zrax
.rndup:   lzcnt     rcx, rax
          sub       cl, 64
          not       cl
          mov       rax, 1
          shl       rax, cl

.zrax:    mov       rbx, 32                 ; = s
          mov       rcx, 0                  ; = i
          
.floop:   cmp       rax, rbx
          jle       malloc.floop_b
          jmp       malloc.floop_s
.alloc:   mov       r12, rax
          mov       r13, rcx
          mov       rax, 9                  ; syscall mmap
          mov       rdi, 0
          mov       rsi, 4096
          mov       rdx, 7
          mov       r10, 0x22
          mov       r8, -1
          mov       r9, 0
          syscall
          mov       rcx, r13
          mov       [chunktbl+rcx*8], rax
          mov       rax, r12
          jmp       malloc.floop_e
.floop_b: 
          mov       rdx, [chunktbl+rcx*8]
          test      rdx, rdx
          jnz       malloc.floop_e
          cmp       rbx, 4096
          je        malloc.alloc
.floop_s: shl       rbx, 1
          inc       rcx
          jmp       malloc.floop
.floop_e: 
.sloop_s: cmp       rbx, rax
          je        malloc.sloop_e
          mov       r12, [chunktbl+rcx*8]   ; p
          mov       rdx, [r12]              ; p->next
          mov       [chunktbl+rcx*8], rdx
          shr       rbx, 1
          dec       rcx
          mov       qword [r12 + rbx], 0
          mov       rdx, r12
          add       rdx, rbx                ; p + s
          mov       [r12], rdx
          mov       [chunktbl+rcx*8], r12
          jmp       malloc.sloop_s
.sloop_e: 
          mov       rbx, [chunktbl+rcx*8]   ; p
          mov       rdx, [rbx]
          mov       [chunktbl+rcx*8], rdx
          mov       [rbx], rax
          mov       rax, rbx
          add       rax, 8
          pop       r13
          pop       r12
          pop       rbx
          ret

;
; free algorithm
;
; [BEHAVIOR IS UNDEFINED IF CALLED ON NON-ALLOCATED BLOCKS]
;
; free(ptr):
; ptr -= 8
; size = *ptr
; partner = ptr ^ size
; i = tzcnt(size) - 5
; while (i < 7) {
;   p = chunktbl[i]
;   o = 0 ; previous of p
;   while (p != 0) {
;     if (p == partner) {
;       // join blocks
;       if (o != 0x0)
;         o->next = p->next
;       else
;         chunktbl[i] = p->next
;       ptr = ptr & partner
;       size <<= 1
;       partner = ptr ^ size
;       
;       // continue loop
;       i += 1
;       continue while true loop
;     }
;     o = p
;     p = p->next
;   }
;   break out of while true
; }
; ptr->next = chunktbl[i]
; chunktbl[i] = ptr
;

free:     sub       rdi, 8                  ; rdi = ptr
          mov       rax, [rdi]              ; rax = size
          cmp       rax, 4096
          jle       free.fnmmap
          mov       rsi, rax
          mov       rax, 11                 ; syscall munmap
          syscall
          ret
.fnmmap:  push      rbx
          mov       rbx, rax                ; rbx = partner
          xor       rbx, rdi
          tzcnt     rcx, rax                ; rcx = i
          sub       rcx, 5

.floop1:  cmp       rcx, 7
          jge       free.floop1e
          
          mov       rdx, [chunktbl+rcx*8]   ; rdx = p
          mov       r8, 0                   ; r8 = o

.floop2:  test      rdx, rdx
          jz        free.floop1e
          cmp       rbx, rdx
          jne       free.felse

          mov       r9, [rdx]
          test      r8, r8
          jz        free.ffirst
          mov       [r8], r9
          jmp       free.ffirste
.ffirst:  mov       [chunktbl+rcx*8], r9
.ffirste: and       rdi, rbx
          shl       rax, 1
          mov       rbx, rax
          xor       rbx, rdi
          inc       rcx
          jmp       free.floop1

.felse:   mov       r8, rdx
          mov       rdx, [rdx]
          jmp       free.floop2

.floop1e: mov       rdx, [chunktbl+rcx*8]
          mov       [rdi], rdx
          mov       [chunktbl+rcx*8], rdi
          pop       rbx
          ret

          section   .data

chunktbl: dq 0x0                            ; k = 5
          dq 0x0                            ; k = 6
          dq 0x0                            ; k = 7
          dq 0x0                            ; k = 8
          dq 0x0                            ; k = 9
          dq 0x0                            ; k = 10
          dq 0x0                            ; k = 11
          dq 0x0                            ; k = 12
