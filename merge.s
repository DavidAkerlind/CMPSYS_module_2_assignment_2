merge:
	subu $sp, $sp, 	24	# Allocate 16 bytes of stack space 
	sw $ra 20($sp)     		# Save the return address ($ra) to the stack at offset 12  
	
	la $a0, print_merge		# Load the address of the string label
	jal print				# print the sring "merge"

	lw $ra, 20($sp)			# Restore the return address from the stack back into $ra

	addu $sp, $sp, 24 		# Deallocate the 16 bytes of stack space (restore stack pointer)

	jr $ra 					# Jump back
	