print_array:
	li $t1, 36
	subu $sp, $sp, $t1 		# make some space for storing and printing
	
	sw $ra, 20($sp)	  		# store the seach-subrutine (this one) return adress

# Store all of the $s regitsters because they are not to be changed after subrutines 
# and we can use them without fear of teh print subroutine to write over them
	sw $s2, 24($sp)			
	sw $s3, 28($sp)
	sw $s4, 32($sp)
	
# Load the arguments in to safe regristers
	li $s2, 0 				# $s2 = start index
	move $s3, $a0           # $s3 = base address of vector = $s3
    move $s4, $a1           # $s4 = $a1 = vector size = $s4
    
for: 
	bge $s2, $s4 end_loop   # if gone trough all elements in vector now end
    
    la $a0, format          # Load format string address
    lw $a1, 0($s3)          # Load the number to print = The next
    jal print               # Call the print subroutine	
    
    addi $s2, $s2, 1		# index++
	addi $s3, $s3, 4		# move to next number in array (4 bytes)
	
	j for
	
end_loop: 

	la $a0, new_line
	jal print

	lw $ra, 20($sp)          # restore return address
    lw $s2, 24($sp)          # restore saved registers
    lw $s3, 28($sp)
    lw $s4, 32($sp)

    addu $sp, $sp, 36        # restore stack pointer

	jr $ra
