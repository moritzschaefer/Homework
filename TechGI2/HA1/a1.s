# c is in a0, n is in a1
main:
add $t0, $zero, $zero # i=0
for:
bge $t0, $a1, endfor # i<n?
sll $t1, $t0, 2
add $t1, $t1, $a0
lw $t2, 0($t1)
bne $t2, $a1, endif #if c[i] == n
addi $a1, $a1, 1
sw $a1, 0($t1)
addi $v0, $zero, 1
jr $ra
endif:
addi $t0, $t0, 1 # i++
j for
endfor:
add $v0, $zero, $zero # return 0
jr $ra
