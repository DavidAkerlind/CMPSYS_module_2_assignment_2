	.data
vector: .word 4,5,2,2,1,6,7,9,5,10
size: .word 10
format: .asciiz "%d " 	# Format for print.s
print_end_merge: .asciiz "end merge"
print_merge: .asciiz "\nmerge\n"
new_line: .asciiz "\n"

	.text
	.include "print.s"
	.globl main
	
main: 
# Load vecor and size in to parameters
	la $s0, vector          # $s0 = base address of array
	la $t0, size
    lw $s1, 0($t0)          # $s1 = array size

# Print array call (int a[], int size) 
	move $a0, $s0		# prepare $a0 with array (base)
	move $a1, $s1		# prepare $a1 with size of array 
	
# Call search function (passing 2 arguments)	jal print_array
	jal print_array
	
# Merge sort call (int a[], int size) 
	move $a0, $s0		# prepare $a0 with array (base)
	move $a1, $s1		# prepare $a1 with size of array 
	
	jal merge_sort
	
	# Print array call (int a[], int size) 
	move $a0, $s0		# prepare $a0 with array (base)
	move $a1, $s1		# prepare $a1 with size of array 
	
# Call search function (passing 2 arguments)	jal print_array
	jal print_array

# End program
	li $v0, 10 
	syscall

print_array:
	subu $sp, $sp, 48 		# make some space for storing and printing
	
	sw $ra, 32($sp)	  		# store the seach-subrutine (this one) return adress

# Store all of the $s regitsters because they are not to be changed after subrutines 
# and we can use them without fear of teh print subroutine to write over them
	sw $s2, 36($sp)			
	sw $s3, 40($sp)
	sw $s4, 44($sp)
	
# Load the arguments in to safe regristers
	li $s2, 0 				# $s2 = start index
	move $s3, $a0           # $s3 = base address of vector = $s3
    move $s4, $a1           # $s4 = $a1 = vector size = $s4
    
    j for
    
for: 
	bge $s2, $s4 end_loop   # if gone trough all elements in vector now end
    
    la $a0, format          # Load format string address
    lw $a1, 0($s3)          # Load the number to print = The next
    jal print               # Call the print subroutine	
    
    addi $s2, $s2, 1		# index++
	addi $s3, $s3, 4		# move to next number in array (4 bytes)
	
	j for
	
end_loop: 

	li $v0, 4
	la $a0, new_line
	syscall

	lw $ra, 32($sp)          # restore return address
    lw $s2, 36($sp)          # restore saved registers
    lw $s3, 40($sp)
    lw $s4, 44($sp)

    addu $sp, $sp, 48        # restore stack pointer

	jr $ra
	
	
merge_sort: 

	subu $sp, $sp, 16 		 # make space for some variables

	sw $ra, 12($sp)	  		 # store the seach-subrutine (this one) return adress
	sw $s0, 8($sp)			 # save base adress for array to be able to use it in different calls
	sw $s1, 4($sp)
	
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
	
# PREPARE	

	move $a0, $s0            # $s0 = base address of vector = $a0
    move $a1, $s1            # $s1 = $a1 = size 
	jal merge				 #  merge(a, size);
	
	j ms_return

merge:
	subu $sp, $sp, 16		# Allocate 16 bytes of stack space 
	$ra, 12($sp)     		# Save the return address ($ra) to the stack at offset 12  
	
	li $v0, 4
	la $a0, print_merge 	# Load the address of the string label 
	syscall 				# print the sring "merge"


	lw $ra, 12($sp)			# Restore the return address from the stack back into $ra


	addu $sp, $sp, 16 		# Deallocate the 16 bytes of stack space (restore stack pointer)

	jr $ra 					# Jump back


end_merge: 
	li $v0, 4
	la $a0, print_end_merge
	syscall

	lw $ra, 0($sp)          # restore return address
	
	addu $sp, $sp, 16       # restore stack pointer
	
	jr $ra
	
	
ms_return:
    lw $ra, 12($sp)
    lw $s0, 8($sp)
    lw $s1, 4($sp)   # restore $s1
    addu $sp, $sp, 16
    jr $ra
	
	
	
