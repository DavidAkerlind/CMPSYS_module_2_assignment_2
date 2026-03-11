# a[k] = b[i];

# $a0 = a[]
# $a1 = b[]
# $a2 = k
# $a3 = i

	subu $sp, $sp, 16 

	lw $t5, 0($s0)		#t5   = a[i]
	sw $t5, 0($s3) 		#v[i] = a[i]


# return a = $v0
# return b = $v1