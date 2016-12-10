global _gcd
    section .text
_gcd:
    push ebp
    mov ebp, esp

    cmp dword [ebp+12], 0
    je .BaseCase

; calculate (a%b), do a recursive function call,
; then quit this function.
.recurse:
    mov eax, [ebp+8]    ; eax <-- 32-bit "a"
    xor edx, edx        ; edx <-- upper 0 bits
    div dword [ebp+12]
    push edx            ; remainder is new "b"
    mov eax, [ebp+12]
    push eax            ; old "b" is new "a"
    call _gcd           ; tail-recursive call
    leave       ; or jump to .done to do this...
    ret

.BaseCase:
    mov eax, [ebp+8]
.done:
    leave
    ret