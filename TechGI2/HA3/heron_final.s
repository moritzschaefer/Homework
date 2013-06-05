#####################################################
#                                                   #
#              POWER                                #
#     HINWEIS: fuer die Rueckgabe $f12 benutzen     #
#                                                   #
#####################################################

# float base -> $a0
# FLOATALSDFKJALFKJSAF laut Hausaufgabenblatt! exponent -> $a1

power:
#IMPLEMENT ME
# f2 be i
# f12 be result

mtc1 $a0, $f0
mtc1 $a1, $f1

li.s $f3, 1.0 # just as constant..
li.s $f12, 1.0 # result = 1.0
li.s $f2, 0.0 #  i = 0.0

for1:
c.lt.s $f2, $f1 # i>=exponent
bc1f endfor1

mul.s $f12, $f12, $f0 # result = result*base

add.s, $f2, $f2, $f3 # i++
j for1
endfor1:

jr	$ra
#####################################################
#                                                   #
#              HERON                                #
#     HINWEIS: fuer die Rueckgabe $f12 benutzen     #
#                                                   #
#####################################################

# float number -> $a0
# float root -> $a1
# int iterations -> $a2

heron:
add $t2, $ra, $zero
mtc1 $a0, $f11 # save number
mtc1 $a0, $f4 # x_n = number x_n1 is $f5
mtc1 $a1, $f6
li.s $f3, 1.0 # just as constant..

add $t0, $zero, $zero # i = 0 
add $t1, $a2, $zero  # save iterations
for2:
bgt $t0, $t1, endfor2 # while i<= iterations

sub.s $f7, $f6, $f3
mfc1 $a0, $f4
mfc1 $a1, $f6
jal power
mov.s $f8, $f12

mfc1 $a0, $f4
mfc1 $a1, $f7
jal power

mul.s $f9, $f12, $f6
mul.s $f7, $f7, $f8
add.s $f7, $f7, $f11

div.s $f5, $f7, $f9
mov.s $f4, $f5

addi $t0, $t0, 1
j for2
endfor2:

mov.s $f12, $f5


jr $t2

#####################################################
#                                                   #
#          DO NOT CHANCE ANYTHING BELOW             #
#                                                   #
#####################################################

##################
# print functions
##################

print_float:
li  $v0,2           # system call code for print_int
syscall             #
jr  $ra             # return

########

print_int:
li $v0, 1
syscall
jr $ra

########

print_string:
li  $v0,4           # system call code for print_string
syscall             # (see textbook Section A.9)
jr  $ra             # return

########

print_newLine:
addi $sp, $sp, -4
sw $a0, 0($sp)          # save a0
li $v0, 4
la $a0, newLine
syscall
lw $a0, 0($sp)
addi $sp, $sp, 4
jr $ra

########

print_results:
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)

jal print_newLine

la $a0, resultString
jal print_string
jal print_float
jal print_newLine

mov.s $f10, $f12
mov.s $f12, $f11
mov.s $f11, $f10

la $a0, expectedString
jal print_string
jal print_float
jal print_newLine

la $a0, statusString
jal print_string

lw $a0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
jr $ra


##################
# data
##################
.data
newLine: .asciiz "\n"
ok: .asciiz "OK!\n"
error: .asciiz "gescheitert!\n"
hello1: .asciiz "Heron-Verfahren zum Approximieren einer Wurzel\n"
ende: .asciiz "Tests beendet."
start: .asciiz "Starte die Tests:\n"
exp: .asciiz "Potenztest... "
test: .asciiz "Heron Test "
dots: .asciiz "... "
skipHeron: .asciiz "Ueberspringe Heron Tests. Bitte beheben sie den/die Fehler in Ihrer Potenzfunktion.\n"
expectedString: .asciiz "  Erwarteter Wert: "
resultString: .asciiz "  Berechneter Wert: "
statusString: .asciiz "  Status: "

sqrt: .float 8.0, 2.0, 16.0, 25.0
root: .float 3.0, 2.0, 4.0, 5.0
iterations: .word 7, 5, 2, 20
expected: .float 2.00000000, 1.41421354, 6.75776625, 1.90365386

test_exp_1: .float 10.0
test_exp_2: .float 2.0
test_exp_res: .float 1024.0

one: .float 1.0
zero: .float 0.0


##################
# main
##################
.text
.globl main

main:
addi $sp, $sp, -28
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 24($sp)
sw $ra, 20($sp)

#print hello
la $a0, hello1
jal print_string
jal print_newLine
la $a0, start
jal print_string

#test power
la $a0, exp
jal print_string

lw $a0, test_exp_2
lw $a1, test_exp_1
jal power

l.s $f11, test_exp_res

jal print_results

c.eq.s $f11, $f12
bc1t power_ok
la $a0, error
jal print_string
la $a0, skipHeron
jal print_string
jal print_newLine
j end_main_for

power_ok:
la $a0, ok
jal print_string
jal print_newLine

#test heron
la $s0, sqrt
la $s1, iterations
la $s2, expected
la $s5, root
add $s3, $0, $0
li $s4, 4

main_for:
beq $s3, $s4, end_main_for
la $a0, test
jal print_string
add $a0, $0, $s3
addi $a0, $a0, 1
jal print_int
la $a0, dots
jal print_string

sll $t0, $s3, 2
add $t1, $t0, $s0
add $t2, $t0, $s1
add $t3, $t0, $s5

lw $a0, 0($t1)
lw $a1, 0($t3)
lw $a2, 0($t2)

addi $sp, $sp, -24
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)

jal heron

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
addi $sp, $sp, 24

sll $t0, $s3, 2
add $t0, $t0, $s2
l.s $f11, 0($t0)

jal print_results

c.eq.s $f11, $f12
bc1f main_error

la $a0, ok
jal print_string
jal print_newLine
j end_main_if

main_error:
la $a0, error
jal print_string
jal print_newLine

end_main_if:
addi $s3, $s3, 1
j main_for

end_main_for:
jal print_newLine
la $a0, ende
jal print_string

lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 24($sp)
lw $ra, 20($sp)
addi $sp, $sp, 28
jr $ra
