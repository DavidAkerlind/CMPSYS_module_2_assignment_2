	.data
	
vector: .word 4,5,2,1
size: .word 4
format: .asciiz "%d " 	# Format for print.s
print_merge: .asciiz "\nmerge\n"
print_ok: .asciiz "\nOK\n"
new_line: .asciiz "\n"

	.text
	.globl main
	.include "print.s"
	.include "print_array.s"
	.include "merge_sort.s"
	.include "merge.s"
	
	
main: 
	subu $sp, $sp, 16 
# Load vecor and size in to parameters
	la $a0, vector          # $a0 = base address of array
	lw $a1, size

# Call search function (passing 2 arguments)	jal print_array
	jal print_array
	
# Merge sort call (int a[], int size) 
	la $a0, vector          # $a0 = base address of array
	lw $a1, size

	jal merge_sort
	
	# Print array call (int a[], int size) 
	#la $a0, vector          # $a0 = base address of array
	#lw $a1, size

	
# Call search function (passing 2 arguments)	jal print_array
	#jal print_array

# End program
	addu $sp, $sp, 16
	li $v0, 10 
	syscall
