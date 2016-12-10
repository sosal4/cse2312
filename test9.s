@ Sosal Pokhrel
@ 1001202713


.global main
.func main
main:
    BL seedrand              @ seed random number generator with current time
    MOV R0, #0              @ initialze index variable
writeloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ writedone          @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    PUSH {R0}               @ backup iterator before procedure call
    PUSH {R2}               @ backup element address before procedure call
    BL getrand             @ get a random number
    POP {R2}                @ restore element address
    STR R0, [R2]            @ write the address of a[i] to a[i]
    POP {R0}                @ restore iterator
    ADD R0, R0, #1          @ increment index
    B  writeloop           @ branch to next loop iteration
    
writedone:
    MOV R0, #0              @ initialze index variable
   
readloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf              @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
    
readdone:
    MOV R0, #0		        @ initialize index variable R0 with 0, i = 0
    LDR R1, =a      	    @ get the address of array a
    LSL R2, R0, #2	        @ multiply index*4 to get array offset
    ADD R2, R1, R2	        @ R2 now has the element address
    LDR R8, [R2]	        @ store the first element in R8
    ADD R0, R0, #1	        @ increment index, i=i+1;
    B  getMin	            @ branch to procedure _getMin to find minimum
    
getMin:
    CMP R0, #10             
    BEQ minDone		        @ branch to procedure minDone when minimum is found
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    CMP R1, R8              @ compare R1 with R8
    MOVLT R8, R1	        @ move R1 to R8 if it is smaller than R8
    ADD R0, R0, #1          @ increment index
    B  getMin  
    
minDone:
    MOV R0, #0		        @ initialize index variable R0 with 0, i = 0
    LDR R1, =a      	    @ get the address of array a
    LSL R2, R0, #2	        @ multiply index*4 to get array offset
    ADD R2, R1, R2	        @ R2 now has the element address
    LDR R9, [R2]	        @ store the first element in R9
    ADD R0, R0, #1	        @ increment index
    B  getMax	            @ branch to procedure _getMax to find maximum
    
getMax:
    CMP R0, #10             
    BEQ maxDone		        
    LDR R1, =a              
    LSL R2, R0, #2          
    ADD R2, R1, R2          
    LDR R1, [R2]            
    CMP R1, R9             
    MOVGT R9, R1	        
    ADD R0, R0, #1          
    B   getMax             
    
maxDone:
    MOV R1, R9
    MOV R2, R8
    BL printResults 

goSearch:
    BL takeInput
    BL _scanf
    MOV R10, R0
    MOV R3, #-1
    MOV R0, #0		        @ initialize index variable R0 with 0, i = 0
    LDR R1, =a      	    @ get the address of array a
    LSL R2, R0, #2	        @ multiply index*4 to get array offset
    ADD R2, R1, R2	        @ R2 now has the element address
    LDR R9, [R2]	        @ store the first element in R9
    ADD R0, R0, #1	        @ increment index
    B  beginSearch	            @ branch to procedure _getMax to find maximum
    
beginSearch:
    CMP R0, #11             
    BEQ searchDone		        
    LDR R1, =a              
    LSL R2, R0, #2          
    ADD R2, R1, R2          
    LDR R1, [R2]            
    CMP R10, R9
    SUB R9,R0,#1
    MOVEQ R3, R9
    MOV R9, R1
    ADD R0, R0, #1          
    B   beginSearch   

searchDone:
    MOV R1, R3
    BL getSearch
    B goSearch
    
getrand:
    PUSH {LR}               @ backup return address
    BL rand                 @ get a random number
    MOV R1, R0
    MOV R2, #1000
    BL mod_unsigned
    POP {PC}                
   
mod_unsigned:
    cmp R2, R1              @ check to see if R1 >= R2
    MOVHS R0, R1            @ swap R1 and R2 if R2 > R1
    MOVHS R1, R2            @ swap R1 and R2 if R2 > R1
    MOVHS R2, R0            @ swap R1 and R2 if R2 > R1
    MOV R0, #0              @ initialize return value
    B modloopcheck          @ check to see if
modloop:
        ADD R0, R0, #1      @ increment R0
        SUB R1, R1, R2      @ subtract R2 from R1
modloopcheck:
        CMP R1, R2          @ check for loop termination
        BHS modloop        @ continue loop if R1 >= R2
    MOV R0, R1              @ move remainder to R0
    MOV PC, LR              @ return   
    
printResults:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =results        @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ return
    
takeInput:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =getValue        @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ return

getSearch:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =printSearch        @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ return
    
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
    
_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return

seedrand:
    PUSH {LR}               @ backup return address
    MOV R0, #0              @ pass 0 as argument to time call
    BL time                 @ get system time 
    MOV R1, R0              @ pass sytem time as argument to srand
    BL srand                @ seed the random number generator
    POP {PC}                @ return 
   
.data
.balign 4
a:              .skip       400
printf_str:     .asciz      "a[%d] = %d\n"
printSearch:    .asciz       "%d\n"
getValue:        .asciz        "Enter Search Value: "
format_str:    .asciz        "%d"
results: 	.asciz    "Minimum = %d\nMaximum = %d\n"
