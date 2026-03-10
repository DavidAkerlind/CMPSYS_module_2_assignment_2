merge_sort: 
	subu $sp, $sp, 32 		 # make space for some variables

	sw $ra, 28($sp)	  		 # store the seach-subrutine (this one) return adress
	sw $s0, 24($sp)			 # save base adress for array to be able to use it in different calls
	sw $s1, 20($sp)
	
	move $s0, $a0            # $s0 = base address of vector = $s0
    move $s1, $a1            # $t1 = $a1 = vector size = $t1
    
	ble $s1, 1 ms_return	 # Compare the SIZE with 1 :: IF size > 1: continue, ELSE: end
	
	divu $t2, $s1, 2		 # int half = size / 2 = $t2 = HALF
	
# PREPARE mergeSort(a, half);
	move $a0, $s0            # $t0 = base address of vector = $t0
    move $a1, $t2            # $t2 = $a1 = size / 2
   
	jal merge_sort			 # mergeSort(a, half = $t2 );

# PREPARE  mergeSort(a + half, size - half);
    divu $t2, $s1, 2         # recalculate half
    mul  $t3, $t2, 4         # byte offset = half * 4
    addu $a0, $s0, $t3       # a + half (in bytes)
    subu $a1, $s1, $t2       # size - half
    
	jal merge_sort			 # mergeSort(a + half, size - half);
	
# PREPARE For MERGE
	move $a0, $s0            # $s0 = base address of vector = $a0
    move $a1, $s1            # $s1 = $a1 = size 
	jal merge				 #  merge(a, size);
	
	j ms_return


ms_return:
    lw $ra, 28($sp)
    lw $s0, 24($sp)
    lw $s1, 20($sp)   # restore $s1
    addu $sp, $sp, 32
    jr $ra
	
	
