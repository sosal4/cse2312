 
@ Sosal Pokhrel
@ ID: 1001202713



.global main
.func main

main:

     BL scanning              
     MOV R5, R0 
     MOV R10, R0
     BL scanning 
     MOV R4, R0 
     MOV R6, R0
     MOV R1, R5
     MOV R2, R4
     BL gcd                 
     MOV R3, R0
     MOV R1, R10
     MOV R2, R6
     BL _printf
     B main

gcd:
    PUSH {LR} 
    CMP R2, #0 
    MOVEQ R0, R1 
    POPEQ {PC}              
    PUSH {R1} 
    PUSH {R2}            
    BL _mod_unsigned
    MOV R12, R0
    MOV R1, R2
    MOV R2, R12
    BL gcd                 
    POP {R2}
    POP {R1}
    POP {PC}  
    
scanning:
    PUSH {LR}               @ store the return address
    PUSH {R1}               @ backup regsiter value
    LDR R0, =format_str     @ R0 contains address of format string
    SUB SP, SP, #4          @ make room on stack
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ remove value from stack
    POP {R1}                @ restore register value
    POP {PC}                @ restore the stack pointer and return

_mod_unsigned:
    cmp R2, R1              @ check to see if R1 >= R2
    MOVHS R0, R1            @ swap R1 and R2 if R2 > R1
    MOVHS R1, R2            @ swap R1 and R2 if R2 > R1
    MOVHS R2, R0            @ swap R1 and R2 if R2 > R1
    MOV R0, #0              @ initialize return value
    B _modloopcheck         @ check to see if
    _modloop:
        ADD R0, R0, #1      @ increment R0
        SUB R1, R1, R2      @ subtract R2 from R1
    _modloopcheck:
        CMP R1, R2          @ check for loop termination
        BHS _modloop        @ continue loop if R1 >= R2
    MOV R0, R1              @ move remainder to R0
    MOV PC, LR              @ return

 
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =print_str      @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return



.data 
 number: .word 40
 format_str: .asciz "%d"
 print_str:     .asciz      "The gcd of %d and %d is %d\n"
 