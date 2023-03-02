;label:   opcode    operands, operands      ; comment
;
; string.i: C strings, with "managed" memory
; 
; methods:
;
;  C string methods
; 
;  - memset (rdi = void* p, rsi = int x, rdx = size)
;  - strlen (rdi = char* str)
;  - strcpy (rdi = char* dst, rsi = char* src)
;  - strcmp (rdi = char* l, rsi = char* r)
;
;  String interface
;
;  - String_ctor_empty (rdi = size) -> String*
;  - String_ctor_cstr (rdi = char* s) -> String*
;  - String_ctor_copy (rdi = String* other) -> String*
;  - String_assign (rdi = String*, rsi = String*) -> String* [ modifies/returns rdi ]
;  - String_dtor (rdi = String*)
;  - String_get_data (rdi = String*) -> char*
;  - String_get_capacity (rdi = String*) -> int
;  - String_at (rdi = String*, rsi = int i) -> char
;  - String_change_capacity (rdi = String*, rsi = int newCapacity) -> void [ modifies rdi ]
;  - String_grow (rdi = String*) -> void [ modifies rdi ]
;  - String_append (rdi = String*, rsi = char c) -> void [ modifies rdi ]
;  - String_concat (rdi = String*, rsi = String*) -> void [ modifies rdi ]
;  - String_compare (rdi = String*, rsi = String* other) -> result (-/0/+)
;  - String_starts_with (rdi = String*, rsi = String* prefix) -> bool (0/1)
;
;  String utility methods
;
;  - String_from_int (rdi = int) -> String*
;

          extern    memset
          extern    strlen
          extern    strcpy
          extern    strcmp

          extern    String_ctor_empty
          extern    String_ctor_cstr
          extern    String_ctor_copy
          extern    String_assign
          extern    String_dtor

          extern    String_get_data
          extern    String_get_size
          extern    String_get_capacity

          extern    String_at
          extern    String_change_capacity
          extern    String_append
          extern    String_concat
          extern    String_compare
          extern    String_starts_with
