# a[k] = b[i]
# $a0 = base address of a[]
# $a1 = base address of b[]
# $a2 = k
# $a3 = i

copy_element:
    subu $sp, $sp, 16

    sll  $t0, $a3, 2        # i * 4 (byte offset)
    addu $t0, $a1, $t0      # address of b[i]
    lw   $t1, 0($t0)        # $t1 = b[i]

    sll  $t2, $a2, 2        # k * 4 (byte offset)
    addu $t2, $a0, $t2      # address of a[k]
    sw   $t1, 0($t2)        # a[k] = b[i]

    move $v0, $a0            # return base address of a[]
    move $v1, $a1            # return base address of b[]

    addu $sp, $sp, 16
    jr   $ra