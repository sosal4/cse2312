###########################################################################################
#
#  simple-sqrt.s - A simple but inefficient MIPS assembly language program 
#	that calculates square roots.  I/O is done to the console under SPIM.
# 
#  Author: 		Michael Frank
#  Date written: 	Feb. 8, 2006
#
###########################################################################################

#==========================================================================================
	.text		# Begin text segment.
	.globl	main	# Make label "main" globally accessible
	
#------------------------------------------------------------------------------------------
#  main() - Repeatedly prompts the user to enter numbers, calculates their square roots,
#	and prints them, with suitable error messages.
#
#  Input:	Integers entered in ASCII on the SPIM console.
#  Output:  	Square root results and other messages displayed on the SPIM console.
#  Errors:	Displays an error message if the number entered is negative.
#------------------------------------------------------------------------------------------
main:	# Push our return address $ra onto the stack.
	addi	$sp, $sp, -8		# Make room for 2 words on the stack.
	sw	$s0, 0($sp)		# Preserve $s0 at the top of the stack.
	sw	$ra, 4($sp)		# Preserve $ra in the second slot.
	
	# Print the program title message to the console.
	la	$a0, title_msg		# Load $a0 with the address of the string to print.
	jal	print_str_nl		# Call print_str_nl($a0) function defined below.

	# Infinite loop to accept numbers and print their square roots.
infloop:
	# Prompt the user to type a number to take the square root of.
	la	$a0, prompt_msg		
	jal	print_str		# Call print_str(prompt_msg)
	
	# Read the integer to take the square root of from the user.
	jal	read_int		# Integer read is returned in $v0
	
	# If the integer is non-negative, skip to the square root calculation.
	bgez	$v0, do_sqrt		# if ($v0 >= 0) goto do_sqrt
	
	# The integer is negative.  Print the error message.
	la	$a0, error_msg
	jal	print_str_nl		# Call print_str_nl(error_msg)
	
	j	infloop			# Get another integer.

do_sqrt:
	# Calculate the square root.
	move	$a0, $v0		# Pass integer that was typed as argument to sqrt()
	jal	sqrt			# Call sqrt() function to return result
	move	$s0, $v0		# Preserve result in $s0.
	
	# Print a message introducing the result.
	la	$a0, result_msg
	jal	print_str		# Call print_str(result_msg)
	
	# Print the actual result.
	move	$a0, $s0		# $a0 <- $s0 (square root result preserved earlier)
	jal	print_int		# Call print_int($a0)
	
	# Print a newline.
	jal	print_nl		# Call print_nl()
	
	j	infloop			# Lather, rinse, repeat.

	# Due to the infinite loop, we never get to the code below here, so it 
	# really doesn't matter.  However, if we did ever break out of the loop, 
	# here is what we should do.

	# Pop $s0 & $ra off the stack
	lw	$s0, 0($sp)		# Recover $s0 from the stack.
	lw	$ra, 4($sp)		# Recover our return address from the stack.
	addi	$sp, $sp, 8		# Step the stack pointer over them both.
	
	# Return to caller of main() - Runtime environment.
	jr	$ra			# Jump back into our caller.
# End of main routine.

#------------------------------------------------------------------------------------------
# Subroutine:	sqrt
# Usage:	v0 = sqrt(a0)
# Description:
# 	Takes a positive signed integer in $a0 and returns its integer square root
#	(i.e., the floor of its real square root) in $v0.
# Arguments:	$a0 - A positive signed integer to take the square root of.
# Result:	$v0 - The floor of the square root of the argument, as an integer.
# Side effects:	The previous contents of register $t0 are trashed.
# Local variables:	
#	$v0 - Number r currently being tested to see if it is the square root.
#	$t0 - Square of r.
# Stack usage:  none
#------------------------------------------------------------------------------------------
sqrt:	addi	$v0, $zero, 0	# r := 0
loop:	mul	$t0, $v0, $v0	# t0 := r*r
	bgt	$t0, $a0, end	# if (r*r > n) goto end
	addi	$v0, $v0, 1	# r := r + 1
	j	loop		# goto loop
end:	addi	$v0, $v0, -1	# r := r - 1
	jr	$ra		# return with r-1 in $v0

#------------------------------------------------------------------------------------------
# print_int($a0):  This small subroutine takes an integer in argument register $a0, and 
#	prints it to the console using the SPIM system services.
#
# Arguments:	$a0 - Integer to print.
# Outputs:	Prints the integer to the console.
# Side effect:	Trashes register $v0.
#------------------------------------------------------------------------------------------
print_int:
	li	$v0, 1			# Select code for "print integer" service
	syscall				# Call the operating system service
	jr	$ra			# Return from print_int()

#------------------------------------------------------------------------------------------
# print_str($a0):  This small subroutine takes a pointer to a zero-terminated string in 
# argument register $a0, and prints it to the console using the SPIM system services.
#
# Arguments:	$a0 - Pointer to string to print.
# Outputs:	Prints zero-terminated string starting at MEM[$a0] to console.
# Side effect:	Trashes register $v0.
#------------------------------------------------------------------------------------------
print_str:
	li	$v0, 4			# Select code for "print_string" service
	syscall				# Call the operating system service
	jr	$ra			# Return from print_str

#------------------------------------------------------------------------------------------
# print_nl():  Prints a newline character sequence to the SPIM console.
#
# Outputs:	Prints a newline character or CR/LF sequence to the SPIM console.
# Side effect:	Trashes registers $a0 and $v0.
#------------------------------------------------------------------------------------------
print_nl:
	# Push our return address $ra onto the stack.
	addi	$sp, $sp, -4		# Make room for 1 word on the stack.
	sw	$ra, 0($sp)		# Store our return address there.

	# Call print_str(newline)
	la	$a0, newline		# Get pointer to newline string.
	jal	print_str
	
	# Pop our return address off the stack
	lw	$ra, 0($sp)		# Recover our return address from the stack.
	addi	$sp, $sp, 4		# Step the stack pointer over it.
	
	# Return to caller.
	jr	$ra			# Jump back into our caller.

#------------------------------------------------------------------------------------------
# print_str_nl($a0):  This small subroutine takes a pointer to a zero-terminated string in 
#    argument register $a0, and prints it to the console using the SPIM system services,
#    followed by a newline sequence.
#
# Arguments:	$a0 - Pointer to string to print.
# Outputs:	Prints zero-terminated string starting at MEM[$a0] to console, plus newline.
# Side effect:	Trashes register $v0.
#------------------------------------------------------------------------------------------
print_str_nl:
	# Push our return address $ra onto the stack.
	addi	$sp, $sp, -4		# Make room for 1 word on the stack.
	sw	$ra, 0($sp)		# Store our return address there.

	# Call print_str($a0)
	jal	print_str
	
	# Call print_nl()
	jal	print_nl
	
	# Pop our return address off the stack
	lw	$ra, 0($sp)		# Recover our return address from the stack.
	addi	$sp, $sp, 4		# Step the stack pointer over it.
	
	# Return to caller.
	jr	$ra			# Jump back into our caller.

#------------------------------------------------------------------------------------------
# read_int():  This small subroutine reads and returns an integer that was 
#	entered by the user into the SPIM console.
#
# Arguments:	None.
# Inputs:	An integer typed in ASCII by the user on the SPIM console.
# Return value:	The value of the integer typed is returned in $v0.
#------------------------------------------------------------------------------------------
read_int:
	li	$v0, 5			# Select code for "read integer" service
	syscall				# Call the operating system service
	jr	$ra			# Return from read_int
# End of read_int() subroutine.

#==========================================================================================
# Begin data segment.

	.data				# Begin data segment.
	
# Various messages that our program will print.

title_msg:					# A label for our string.
	.asciiz	"Square Root Program"		# zero-terminated string to print.
prompt_msg:
	.asciiz "Enter input number: " 
result_msg:
	.asciiz "The square root of that number is "
error_msg:
	.asciiz "Error: Can't take the square root of a negative number!"
newline:
	.asciiz "\n"
