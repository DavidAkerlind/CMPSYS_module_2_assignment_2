merge:
	subu $sp, $sp, 48	# Allocate 16 bytes of stack space 
	sw $ra, 44($sp)	  		 
	# store the seach-subrutine (this one) return adress
	# save base adress for array to be able to use it in different calls
	sw $s0, 40($sp)		# base adress for vector = $s0
	sw $s1, 36($sp)						  # size = $s1
	
	move $s0, $a0			# base = $t0
	move $s1, $a1			# size = $t1
	
	
# half = $t2
	div $t2, $s1, 2    		# half = $t2

# b[] = $t3 
	sll $t3, $s1, 2         # $t4 = size * 4 
	subu $sp, $sp, $t3      # allocate b[] on stack
	move $t3, $sp           # $t3 = base address of b[]
	move $s3, $t3
	
# i = $t4
	li $t4, 0
	
m_for: 
	bge $t4, $s1, m_end_for

	lw $t5, 0($s0)		#t4=a[i]
	sw $t5, 0($t3) 		#v[i]=a[i]
	 
	addi $s0 $s0, 4 	# move to next element in v[]
	addi $t3 $t3, 4		# move to next element in a[]
	addi $t4, $t4, 1	# i++
	
	j m_for
	
m_end_for: 
	move $a0, $s3
	move $a1, $s1
	
	jal print_array

	j m_return


m_return:
	sll $t3, $s1, 2			# recalculate size * 4
	addu $sp, $sp, $t3		# FREE b[] space first
	
	lw $ra, 44($sp)			# Restore the return address from the stack back into $ra
	lw $s0, 40($sp)
	lw $s1, 36($sp)
	addu $sp, $sp, 48 		# Deallocate the 16 bytes of stack space (restore stack pointer)

	jr $ra 					# Jump back
	
