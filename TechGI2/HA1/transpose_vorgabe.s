#####################################
#                                   #
#     Einstellung für die Tests     #
#                                   #
#####################################
.data
# Ueber die Variable "swapTestDisable"
# kann der Test aktiviert oder deaktiviert
# werden.
#
#   0 = aktiviert
#   1 = deaktiviert
swapTestDisable: .word 0

# Um einzelne Tests zu deaktivieren
# setzen sie bitte die folgende
# Variable "testAmount".
#
#   0 = alle Tests abschalten
#   1 = nur Tests mit validen Eingaben
#   2 = nur Tests mit falschen Eingaben
#   3 = alle Tests
testAmount: .word 3

#####################################
#                                   #
#   Implementierung der Studenten   #
#                                   #
#####################################
.text

##################################
#   $a0 = pointer to array
#   $a1 = n
#   $a2 = i
#   $a3 = j
##################################
swap:
# calculate offset for i,j:
# i*n+j 
# and for j,i
# j*n+i


mul $t1, $a2, $a1  # here begins swap#calculate  posision in array of i,j-value
add $t1, $t1, $a3 
sll $t1, $t1, 2
add $t1, $t1, $a0
lw $t2, 0($t1) # save i,j-value

mul $t0, $a3, $a1 #calculate position of j,i value in array
add $t0, $t0, $a2
sll $t0, $t0, 2 
add $t0, $t0, $a0 
lw $t3, 0($t0) # save j,i-value
sw $t2, 0($t0) # store i,j at j,i
sw $t3, 0($t1) # store j,i at i,j

jr $ra #return tu caller



##################################
#   $a0 = pointer to matrix-array
#   $a1 = max row-count equals n
#   Returns pointer to array via $v0
##################################
transpose: #transpose begin
#save return adress and used save registers
addi $sp, $sp, -32 
sw $ra, 0($sp)
sw $s0, -4($sp)
sw $s1, -8($sp)
sw $s2, -12($sp)
sw $s3, -16($sp)
sw $s4, -20($sp)
sw $s5, -24($sp)
sw $s6, -28($sp)

add $s5, $a0, $zero #save parameters array_pointer and n
add $s6, $a1 $zero
addi $s0, $a1, 0 # counter1 = n
outerfor:
beq $s0, $zero, endouterfor # while count1 != 0
addi $s0, $s0, -1 # counter1--
addi $s1, $a1, -1 #counter2 = n-1
innerfor:
ble $s1, $s0, endinnerfor  # while counter2 > counter1
add $a0, $s5, $zero # init parameters for swap #arraypointer
add $a1, $s6, $zero # n
add $a2, $s0, $zero # i
add $a3, $s1, $zero # 
jal swap # call swap

addi $s1, $s1, -1 #count2 -=1
j innerfor #return to inner loop
endinnerfor:
j outerfor #return to outer loop
endouterfor:
add $v0, $s5, $zero #init return value (array pointer)

lw $ra, 0($sp) #restore return address and save registers
lw $s0, -4($sp)
lw $s1, -8($sp)
lw $s2, -12($sp)
lw $s3, -16($sp)
lw $s4, -20($sp)
lw $s5, -24($sp)
lw $s6, -28($sp)
addi $sp, $sp, 32

jr $ra #return to caller

#####################################
#                                   #
#   DO NOT CHANGE ANYTHING BELOW    #
#                                   #
#     AB HIER NICHTS VERÄNDERN      #
#                                   #
#####################################
print_int:
li $v0, 1
syscall
jr $ra
print_string:
li  $v0,4
syscall
jr  $ra
print_newLine:
addi $sp, $sp, -4
sw $a0, 0($sp)
li $v0, 4
la $a0, newLine
syscall
lw $a0, 0($sp)
addi $sp, $sp, 4
jr $ra
print_space:
addi $sp, $sp, -4
sw $a0, 0($sp)
li $v0, 4
la $a0, space
syscall
lw $a0, 0($sp)
addi $sp, $sp, 4
jr $ra
print_matrix:
addi $sp, $sp, -20
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
add $s0, $0, $a0
add $s1, $0, $a1
add $s2, $0, $0
printI:
bge $s2, $s1, endPrintI
add $s3, $0, $0
jal print_space
jal print_space
jal print_space
jal print_space
printJ:
bge $s3, $s1, endPrintJ
mul $t0, $s1, $s2
add $t0, $t0, $s3
sll $t0, $t0, 2
add $t0, $t0, $s0
lw $a0, 0($t0)
jal print_int
jal print_space
add $s3, $s3, 1
j printJ
endPrintJ:
jal print_newLine
addi $s2, $s2, 1
j printI
endPrintI:
lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
addi $sp, $sp, 20
jr $ra
.data
swap_data: .word 1,2,3,4,5,6,7,8,9
swap_rowCount: .word 3
swap_test1: .word 0,1
swap_test2: .word 1,2
swap_test3: .word 2,2
swap_expected: .word 1,4,3,2,5,8,7,6,9
test1_data: .word 1,2,4,2,1,3,3,3,1
test1_rowCount: .word 3
test1_expected: .word 1,2,3,2,1,3,4,3,1
test2_data: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
test2_rowCount: .word 5
test2_expected: .word 1,6,11,16,21,2,7,12,17,22,3,8,13,18,23,4,9,14,19,24,5,10,15,20,25
test3_data: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
test3_rowCount: .word 4
test3_expected: .word 1,5,9,13,2,6,10,14,3,7,11,15,4,8,12,16,17,18,19,20,21,22,23,24,25
test3_expectedRowCount: .word 5
test4_data: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
test4_rowCount: .word 7
test4_dummyData: .word 1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0
test4_expected: .word 1,8,15,22,3,0,7,2,9,16,23,4,1,8,3,10,17,24,5,2,9,4,11,18,25
test4_expectedRowCount: .word 5
newLine: .asciiz "\n"
space: .asciiz " "
ok: .asciiz "OK\n"
error: .asciiz "FEHLER\n"
welcome: .asciiz "Matrix-transpose fuer n x n Matritzen\n"
swapString: .asciiz "Swap-Test wird ausgefuehrt.\n"
matrixTestsSkipped: .asciiz "Die Matrix-Tests werden uebersprungen!"
testAmount0String: .asciiz "Alle Matrix-Tests deaktiviert!"
testAmount1String: .asciiz "Nur Matrix-Tests mit validen Eingaben werden ausgefuehrt.\n\n"
testAmount2String: .asciiz "Nur Matrix-Tests mit falschen Eingaben werden ausgefuehrt.\n\n"
testAmount3String: .asciiz "Alle Matrix-Tests werden ausgefuehrt.\n\n"
testStart: .asciiz "Starte Test: \n"
validTestsString: .asciiz "#####  valide Eingaben  #####\n"
invalidTestsString: .asciiz "#####  falsche Eingaben  #####\n"
expectedString: .asciiz "  Erwartet:\n"
resultString: .asciiz "  Berechnet:\n"
statusString: .asciiz "  Status: "
.text
matrixCompare:
add $t0, $0, $0
compareI:
bge $t0, $a2, endCompareI
add $t1, $0, $0
compareJ:
bge $t1, $a2, endCompareJ
mul $t2, $t0, $a2
add $t2, $t2, $t1
sll $t2, $t2, 2
add $t3, $t2, $a1
add $t2, $t2, $a0
lw $t2, 0($t2)
lw $t3, 0($t3)
bne $t2, $t3, notEqual
addi $t1, $t1, 1
j compareJ
endCompareJ:
addi $t0, $t0, 1
j compareI
endCompareI:
add $v0, $0, $0
jr $ra
notEqual:
addi $v0, $0, 1
jr $ra
swapTest:
addi $sp, $sp, -8
sw $ra, 0($sp)
sw $s0, 4($sp)
la $a0, swap_data
lw $a1, swap_rowCount
la $t0, swap_test1
lw $a2, 0($t0)
lw $a3, 4($t0)
jal swap
la $a0, swap_data
lw $a1, swap_rowCount
la $t0, swap_test2
lw $a2, 0($t0)
lw $a3, 4($t0)
jal swap
la $a0, swap_data
lw $a1, swap_rowCount
la $t0, swap_test3
lw $a2, 0($t0)
lw $a3, 4($t0)
jal swap
la $a0, expectedString
jal print_string
la $a0, swap_expected
lw $a1, swap_rowCount
jal print_matrix
la $a0, resultString
jal print_string
la $a0, swap_data
lw $a1, swap_rowCount
jal print_matrix
la $a0, statusString
jal print_string
la $a0, swap_data
la $a1, swap_expected
lw $a2, swap_rowCount
jal matrixCompare
beq $v0, $0, swapSuccess
la $a0, error
jal print_string
addi $s0, $0, 1
j endSwap
swapSuccess:
la $a0, ok
jal print_string
add $s0, $0, $0
endSwap:
jal print_newLine
add $v0, $s0, $0
lw $ra, 0($sp)
lw $s0, 4($sp)
add $sp, $sp, 8
jr $ra
validTests:
addi $sp, $sp, -8
sw $ra, 0($sp)
sw $s0, 4($sp)
la $a0, validTestsString
jal print_string
la $a0, testStart
jal print_string
la $a0, expectedString
jal print_string
la $a0, test1_expected
lw $a1, test1_rowCount
jal print_matrix
la $a0, resultString
jal print_string
la $a0, test1_data
lw $a1, test1_rowCount
jal transpose
add $s0, $v0, $0
add $a0, $v0, $0
jal print_matrix
la $a0, statusString
jal print_string
add $a0, $s0, $0
la $a1, test1_expected
lw $a2, test1_rowCount
jal matrixCompare
beq $v0, $0, test1Success
la $a0, error
jal print_string
j endTest1
test1Success:
la $a0, ok
jal print_string
endTest1:
jal print_newLine
la $a0, testStart
jal print_string
la $a0, expectedString
jal print_string
la $a0, test2_expected
lw $a1, test2_rowCount
jal print_matrix
la $a0, resultString
jal print_string
la $a0, test2_data
lw $a1, test2_rowCount
jal transpose
add $a0, $v0, $0
jal print_matrix
la $a0, statusString
jal print_string
add $a0, $s0, $0
la $a1, test1_expected
lw $a2, test1_rowCount
jal matrixCompare
beq $v0, $0, test2Success
la $a0, error
jal print_string
j endTest2
test2Success:
la $a0, ok
jal print_string
endTest2:
jal print_newLine
jal print_newLine
lw $ra, 0($sp)
lw $s0, 4($sp)
add $sp, $sp, 8
jr $ra
invalidTests:
addi $sp, $sp, -8
sw $ra, 0($sp)
sw $s0, 4($sp)
la $a0, invalidTestsString
jal print_string
la $a0, testStart
jal print_string
la $a0, expectedString
jal print_string
la $a0, test3_expected
lw $a1, test3_expectedRowCount
jal print_matrix
la $a0, resultString
jal print_string
la $a0, test3_data
lw $a1, test3_rowCount
jal transpose
add $s0, $v0, $0
add $a0, $v0, $0
lw $a1, test3_expectedRowCount
jal print_matrix
la $a0, statusString
jal print_string
add $a0, $s0, $0
la $a1, test3_expected
lw $a2, test3_expectedRowCount
jal matrixCompare
beq $v0, $0, test3Success
la $a0, error
jal print_string
j endTest3
test3Success:
la $a0, ok
jal print_string
endTest3:
jal print_newLine
la $a0, testStart
jal print_string
la $a0, expectedString
jal print_string
la $a0, test4_expected
lw $a1, test4_expectedRowCount
jal print_matrix
la $a0, resultString
jal print_string
la $a0, test4_data
lw $a1, test4_rowCount
jal transpose
add $s0, $v0, $0
add $a0, $v0, $0
lw $a1, test4_expectedRowCount
jal print_matrix
la $a0, statusString
jal print_string
add $a0, $s0, $0
la $a1, test4_expected
lw $a2, test4_expectedRowCount
jal matrixCompare
beq $v0, $0, test4Success
la $a0, error
jal print_string
j endTest4
test4Success:
la $a0, ok
jal print_string
endTest4:
jal print_newLine
lw $ra, 0($sp)
lw $s0, 4($sp)
add $sp, $sp, 8
jr $ra
.globl main
main:
addi $sp, $sp, -8
sw $ra, 0($sp)
sw $s0, 4($sp)
la $a0, welcome
jal print_string
jal print_newLine
lw $t0, swapTestDisable
bne $t0, $0, matrixTests
la $a0, swapString
jal print_string
jal swapTest
add $s0, $v0, $0
beq $s0, $0, matrixTests
lw $t0, testAmount
beq $t0, $0, case0
la $a0, matrixTestsSkipped
jal print_string
j endMain
matrixTests:
lw $t0, testAmount
beq $t0, $0, case0
addi $t1,$0, 1
beq $t0, $t1, case1
addi $t1, $t1, 1
beq $t0, $t1, case2
j case3
case0:
la $a0, testAmount0String
jal print_string
j endMain
case1:
la $a0, testAmount1String
jal print_string
jal validTests
j endMain
case2:
la $a0, testAmount2String
jal print_string
jal invalidTests
j endMain
case3:
la $a0, testAmount3String
jal print_string
jal validTests
jal invalidTests
endMain:
lw $ra, 0($sp)
lw $s0, 4($sp)
addi $sp, $sp, 8
jr $ra
