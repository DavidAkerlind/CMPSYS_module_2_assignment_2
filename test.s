	.data
vector: .word 4,5,2,-2,1,6,7,9,-5,10,99,32,98,42,12,41,29,22,77,62
#vector: .word 4,5,2,-2,1,6,7,9,-5,10
size: .word 20
format: .asciiz "%d " 	# Format for print.s
new_line: .asciiz "\n"


	.text
	.globl main
	.include "print.s"
	.include "print_array.s"
	.include "merge_sort.s"
	.include "merge.s"
	

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
	
	
merge:
	subu $sp, $sp, 52
    sw $ra, 48($sp)
    sw $s0, 44($sp)
    sw $s1, 40($sp)
    sw $s2, 36($sp)
    sw $s3, 32($sp)
    sw $s4, 28($sp)
    sw $s5, 24($sp)
    sw $s6, 20($sp)
	
	move $s0, $a0			# base a[] = $s0
	move $s1, $a1			# size = $s1
	
# half = $s2
	div $s2, $s1, 2    		# half = $s2

# b[] = $s3 
	sll $t0, $s1, 2         # $t0 = size * 4($t3 is teh size we need for b[])
	subu $sp, $sp, $t0      # allocate $t0 space b[] on stack
	move $s3, $sp           # $s3 = base address of b[]
	
# i = $t4
	li $t4, 0
	
m_for:
    bge  $t4, $s1, m_end_for
    sll  $t0, $t4, 2        # i * 4
    addu $t1, $s0, $t0      # address of a[i]
    lw   $t2, 0($t1)        # t2 = a[i]
    addu $t3, $s3, $t0      # address of b[i]
    sw   $t2, 0($t3)        # b[i] = a[i]
    addi $t4, $t4, 1        # i++
    j    m_for
	
# $s0 = base address of a[]
# $s1 = size
# $s2 = half
# $s3 = base address of b[]
# $s4 = i
# $s5 = j
# $s6 = k


# this restores some values to continue the merge
m_end_for:
    li   $s4, 0             # i = 0
    move $s5, $s2           # j = half
    li   $s6, 0             # k = 0
	
m_while1: #  while (i < half && j < size)
	bge $s4, $s2, m_while2 # i < half
	bge $s5, $s1, m_while2 # j < size
	
# Load b[i] = $s3[$s4] in to $t1
    sll  $t0, $s4, 2         # i * 4
    addu $t0, $s3, $t0       # address of b[i]
    lw   $t1, 0($t0)         # $t1 = b[i]
	
# Load b[j] = $s3[$s5] in to $t3
	sll  $t2, $s5, 2         # j * 4
    addu $t2, $s3, $t2       # address of b[j]
    lw   $t3, 0($t2)         # $t3 = b[j]
	
	bgt  $t1, $t3, m_else     # if b[i] > b[j], go to else
	 

m_if: # b[i] <= b[j]
	move $t4, $s4            # i
    addi $s4, $s4, 1         # i++
    j    m_end_if


m_else:  # b[i] > b[j]
    move $t4, $s5            # j
	addi $s5, $s5, 1         # j++
	
m_end_if:
	sll $t0, $t4, 2 		# index * 4
	addu $t0, $s3, $t0
	lw, $t1, 0($t0) 		# Load b[index]
	sll  $t2, $s6, 2        # k * 4
    addu $t2, $s0, $t2
    sw   $t1, 0($t2)        # a[k] = b[index]
    
    addi $s6, $s6, 1         # k++
	j 	 m_while1


# $s0 = base address of a[]
# $s1 = size
# $s2 = half
# $s3 = base address of b[]
# $s4 = i
# $s5 = j
# $s6 = k

m_while2: # Task a[k] = b[i]    IF: while (i < half)
    bge  $s4, $s2, m_while3
    
    sll  $t0, $s4, 2		# calculate the index based i * 4 = $t0
    addu $t0, $s3, $t0		# save the start adress of b[i]
    lw   $t1, 0($t0)        # save value of int b[i] in $t1
    
    sll  $t2, $s6, 2		# calculate the index k * 4 = $t2
    addu $t2, $s0, $t2		# save the start adress of a[k]
    
    sw   $t1, 0($t2)        # a[k] = b[i] / copy the numbers over
    addi $s4, $s4, 1        # i++
    addi $s6, $s6, 1        # k++
    j    m_while2
	
	
m_while3: # TASK: a[k] = b[j]   IF: while (j < size)
    bge  $s5, $s1, m_return
    
    sll  $t0, $s5, 2		# calculate the index based j * 4 = $t0
    addu $t0, $s3, $t0		# save the start adress of b[j]
    lw   $t1, 0($t0)        # b[j] save the value of b[j]
    
    sll  $t2, $s6, 2		# calculate the index based k * 4 = $t2
    addu $t2, $s0, $t2		# save the start adress of a[k]
    
    sw   $t1, 0($t2)        # a[k] = b[j]
    addi $s5, $s5, 1        # j++
    addi $s6, $s6, 1        # k++
    j    m_while3
	
	
m_return:
    sll  $t3, $s1, 2 		# calculate the size of b[] (to now how much we used9
    addu $sp, $sp, $t3      # free b[] space

    lw $s6, 20($sp)         # restore s0-s6 and $ra before returning
    lw $s5, 24($sp)
    lw $s4, 28($sp)
    lw $s3, 32($sp)
    lw $s2, 36($sp)
    lw $s1, 40($sp)
    lw $s0, 44($sp)
    lw $ra, 48($sp)
    addu $sp, $sp, 52 		# remove shadow space
    jr $ra
	

	
main: 
	subu $sp, $sp, 16 
# Call search function (passing 2 arguments)	jal print_array
	# Load vecor and size in to parameters
	la $a0, vector          # $a0 = base address of array
	lw $a1, size
	jal print_array
	
# Merge sort call (int a[], int size) 
	la $a0, vector          # $a0 = base address of array
	lw $a1, size
	jal merge_sort
	
# Call search function (passing 2 arguments)	jal print_array
	# Print array call (int a[], int size) 
	la $a0, vector          # $a0 = base address of array
	lw $a1, size
	jal print_array

# End program
	addu $sp, $sp, 16
	li $v0, 10 
	syscall
	
