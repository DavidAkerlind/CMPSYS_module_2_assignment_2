	.data
	
vector: .word 4,5,2,2,1,6,7,9,5,10
size: .word 10
format: .asciiz "%d " 	# Format for print.s
print_merge: .asciiz "\nmerge\n"
new_line: .asciiz "\n"

	.text
	.include "print.s"
	.include "print_array.s"
	.include "merge_sort.s"
	.include "merge.s"
	.globl main
	
main: 
	subu $sp, $sp, 16 
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
	addu $sp, $sp, 16
	li $v0, 10 
	syscall
