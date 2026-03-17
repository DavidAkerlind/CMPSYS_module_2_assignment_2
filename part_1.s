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
	#la $a0, vector          # $a0 = base address of array
	#lw $a1, size
	#jal print_array

# End program
	addu $sp, $sp, 16
	li $v0, 10 
	syscall
	
