	.data
vector: .word 4,5,2,2,1,6,7,9,5,10
size: .word 10
format: .asciiz "%d" 	# Format for print.s

	.text
	.include "print.s"
	.globl main
	
main: 
# Load vecor and size in to parameters
	la $s0, vector          # $s0 = base address of array
    lw $s1, size            # $s1 = array size

# Print array call (int a[], int size) 
	# Call search function (passing 2 arguments)
	move $a0, $s0		# prepare $a0 with array (base)
	move $a1, $s1		# prepare $a1 with size of array 
	
	jal print_array




# Merge sort call  (int a[], int size) 

# Print array call (int a[], int size) 

# End program

	li $v0, 10 
	syscall

print_array:
	
	subu $sp, $sp, 32 # make some space for storing and printing
	sw $ra, 0($sp)	  		# store the seach-subrutine (this one) return adress
	li $t0, 0 		  # start the index
	
# Load the arguments in to temporary registers

	move $t1, $a0           # $t1 = base address of vector = $t1
    move $t2, $a1           # $t2 = $a1 = vector size = $t2
    
    j for
    
for: 
	bge $t0, $t2 end_loop		# if gone trough all elements in vector now end
    
    subu $sp, $sp, 16 	   # Make spave for print	
    la $a0, format         # Load format string address
    lw $a1, 0($t1)         # Load the number to print
    jal print              # Call the print subroutine
    addu $sp, $sp, 16		
    
    addi $t0, $t0, 1		# index++
	addi $t1, $t1, 4		# move to next number in array (4 bytes)
	
	j for
	
end_loop: 

	lw $ra, 0($sp)
	jr $ra
	
	
	
	
	
	
	
	
	