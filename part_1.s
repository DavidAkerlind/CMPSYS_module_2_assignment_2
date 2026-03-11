	.data
	
vector: .word 4,2,5,1,3,12,8,0,23,99,6,7,11,98,-1,-2,-4
size: .word 17
format: .asciiz "%d " 	# Format for print.s
new_line: .asciiz "\n"

	.text
	.globl main
	.include "print.s"
	.include "print_array.s"
	.include "merge_sort.s"
	.include "merge.s"
	.include "copy_element.s"
	
	
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
