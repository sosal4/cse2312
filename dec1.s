/*************************************************************************
* @file calculator.s
* @brief simple get keyboard character and compare
*
* Simple program of invoking syscall to retrieve a char and two integerd * numbers from keyboard, 
* and perform the desired operation 
*
* @author Sosal Pokhrel   ID:1001202713
*************************************************************************/

	.global main
	.func main

main:

	BL  _scanf              @ branch to scanf procedure with return
	VMOV S0, R0
	BL getchar
	MOV R10, R0
	MOV R2,	R10
	BL comparing
	B main
	


getchar:
	MOV R7, #3 				@ writing syscall, 4
	MOV R0, #0				@ output the stream to the monitor, 1
	MOV R2, #1				@ reading a single character
	LDR R1, =read_char			@ storing the character in data memory
	SWI 0					@ executing the system call
	LDR R0, [R1]				@ moveing the character to the return register
	AND R0, #0xFF				@ mask out all but the lowest 8 bits
	MOV PC, LR 				@ return
	
	
comparing:
	MOV R4, LR
	CMP R2, #'a'				@ comparing against the constant char 'a'
	BLEQ abs				@ branch to make equal handler
	CMP R2, #'s'				@ comparing against the constatn char 's'
	BLEQ sqrt				@ branch to equal handler
	CMP R2, #'p'				@ compare against the constatn char 'p'
	BLEQ prepower				@ branch to equal handler
	CMP R2, #'i'				@ compare against the constatn char 'i'
	BLEQ inverse				@ branch to equal handler
	MOV PC, R4		
	

	
_scanf:
	MOV R4, LR 				@ store LR since scanf call overwrites
	SUB SP, SP, #4				@ make romm on stack
	LDR R0, =format_str			@ R0 contains address of format string
	MOV R1, SP 				@ move SP to R1 to store entry on stack
	BL scanf 				@ call scanf
	LDR R0, [SP]  				@ load value at SP into R0
	ADD SP, SP, #4				@ restore the stack pointer
	MOV PC, R4				@ return



printing:
	PUSH {LR}               @ push LR to stack
    	LDR R0, =print_str     @ R0 contains formatted string address
    	BL printf               @ call printf
    	POP {PC}                @ pop LR from stack and return
		

abs:
	
	VCVT.F64.F32 D4, S0
	VABS.F64 D2, D4
	VMOV R1, R2, D2         
	BL printing
	B main
	
sqrt:
	VCVT.F64.F32 D4, S0
	VSQRT.F64 D2, D4
	VMOV R1, R2, D2         
	BL printing
	B main
	
prepower:
	BL _scanf
	MOV R8, R0
	SUB R8, R8, #1
	MOV R0, #1
	@MOV R5, #1              @ load the denominator
    	VMOV S1, S0             @ move the denominator to floating point register
    	@VCVT.F32.U32 S1, S1     @ convert unsigned bit representation to single float
	B power
	
power:
	VMUL.F32 S2, S0, S0     @ compute S2 = S0 * S1
	VCVT.F64.F32 D4, S2
	VMOV R1, R2, D4 
	BL printing
	@CMP R0, R8
	@BEQ powerdone
	@VLSL S0, S0, S0
	@VMUL.F32 S1, S1, S0      	@ compute S2 = S0 * S1
	@ADD R0, R0, #1
	@B power
	
powerdone:
	VCVT.F64.F32 D4, S1
	VMOV R1, R2, D4 
	BL printing
	B main
	

inverse:
	MOV R9, #1
	VMOV S1, R9
    	VCVT.F32.U32 S1, S1     @ convert unsigned bit representation to single float
	VDIV.F32 S2, S1, S0     @ compute S2 = S1 / S0
   	VCVT.F64.F32 D4, S2     @ covert the result to double precision for printing
    	VMOV R1, R2, D4         @ split the double VFP register into two ARM registers        
	BL printing
	B main


	



.data
format_str:		.asciz		"%f"
read_char:		.ascii		" "
print_str:		.asciz		"%f\n"
val2:           	.float      1.00
