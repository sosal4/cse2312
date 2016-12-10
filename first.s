.global main 
.func main

main:
    MOV R4, #0		    @ move immediate value 0 to temporary resgiter R4
    B _writeArray	    @ branch to _writeArray prodedure 

_writeArray:
    CMP R4, #10        	    @ check to see if (i <10)
    BEQ writedone	    @ branch to writedone procedure
    LDR R6, =a         	    @ get address of a
    LSL R7, R4, #2	    @ multiply index*4 to get array offset
    ADD R7, R6, R7	    @ R2 now has the element address
    BL _scanf          	    @ branch to scanf procedure to get user input
    MOV R5, R0         	    @ move return value R0 to temporary register R5
    STR R5, [R7]       	    @ write the value of R5 to a[i]
    ADD R4, R4, #1     	    @ increment index, i=i+1;
    B _writeArray
    
writedone:
    MOV R0, #0              @ initialize register R0 with the value 0, i = 0
    
readloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ readDone	    @ branch to readDone prodedure 
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration

readDone:
    MOV R0, #0		    @ initialize index variable R0 with 0, i = 0
    LDR R1, =a      	    @ get the address of array a
    LSL R2, R0, #2	    @ multiply index*4 to get array offset
    ADD R2, R1, R2	    @ R2 now has the element address
    LDR R8, [R2]	    @ store the first element in R8
    ADD R0, R0, #1	    @ increment index, i=i+1;
    B  _getMin	            @ branch to procedure _getMin to find minimum
	
_getMin:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ minDone		    @ branch to procedure minDone when minimum is found
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    CMP R1, R8              @ compare R1 with R8
    MOVLT R8, R1	    @ move R1 to R8 if it is smaller than R8
    ADD R0, R0, #1          @ increment index
    B  _getMin              @ branch to next loop iteration

minDone:
    MOV R0, #0		    @ initialize index variable R0 with 0, i = 0
    LDR R1, =a      	    @ get the address of array a
    LSL R2, R0, #2	    @ multiply index*4 to get array offset
    ADD R2, R1, R2	    @ R2 now has the element address
    LDR R9, [R2]	    @ store the first element in R9
    ADD R0, R0, #1	    @ increment index
    B  _getMax	            @ branch to procedure _getMax to find maximum
   
    
_getMax:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ maxDone		    @ branch to procedure maxDone when maximum is found
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    CMP R1, R9              @ compare R1 with R9
    MOVGT R9, R1	    @ move the value of R1 to R9 if R1 is greater than R9
    ADD R0, R0, #1          @ increment index
    B   _getMax             @ branch to next loop iteration
    
maxDone:
    MOV R0, #0		    @ initialize index variable R0 with 0, i = 0
    LDR R1, =a      	    @ get the address of array
    LSL R2, R0, #2	    @ multiply index*4 to get array offset
    ADD R2, R1, R2	    @ R2 now has the element address
    LDR R10, [R2]	    @ store the first element in R10
    ADD R0, R0, #1	    @ increase the index
    B   _getSum	            @ branch to procedure _getSum to find sum
	
_getSum:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ sumDone		    @ branch to procedure maxDone when sum is calculated
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    ADD R10, R10, R1        @ sum+= a_array[i]
    ADD R0, R0, #1          @ increment index
    B  _getSum              @ branch to next loop iteration

sumDone:
    MOV R1, R8		    @ move temporary register value R8 to argument register R1
    MOV R2, R9		    @ move temporary register value R9 to argument register R2
    MOV R3, R10		    @ move temporary register value R10 to argument register R3
    BL _printResults	    @ branch to procedure _printResults when sum is calculated
    B _exit		    @ branch to exit procedure with no return

_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}

_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
    
_printf:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ return

_printResults:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =results        @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ return

    
    
.data

.balign 4
a:              .skip     40
printf_str:     .asciz    "array_a[%d] = %d\n"
format_str:     .asciz    "%d"
results: 	.ascii    "Minimum = %d\nMaximum = %d\nSum = %d\n"
exit_str:       .ascii    "\n"
Contact GitHub 