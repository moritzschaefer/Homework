evaluate:
#
#insert your code here 
#
  # read head->right
  lw $t0, 4($a0)
  beq $t0, $zero, endevaluate

  add $t0, $zero, $zero #init i = 0
  innerwhile:
  add $t1, $zero, $t0
  sll $t1, $t1, 2
  add $t1, $t1, $a1
  lw $t1, 0($t1) # belegung[i]
  lw $t2, 0($a0) # head->name
  beq $t1, $t2, endinnerwhile # belegung[i] != head->name ?
  bne $t1, $zero, if0 # belegung[i] == 0?
  add $v0, $zero, $zero
  jr $ra # return 0
  if0:
  addi $t0, $t0, 2 # i += 2

  j innerwhile
  endinnerwhile:
  addi $t0, $t0, 1 # i++

  sll $t1, $t0, 2
  add $t1, $t1, $a1
  lw $t1, 0($t1)

  bne $t1, $zero, if1 # belegung[i] == 0
  lw $t2, 8($a0)
  add $a0, $t2, $zero  #  head = head->left

  j endif1
  if1: # else
  lw $t2, 4($a0)
  add $a0, $t2, $zero # head = head->right

  endif1:

  j evaluate
  endevaluate:
  lw $v0, 0($a0)
  jr  $ra                     

obdd_to_boolean:

  addi $sp, $sp, -16 # save save-registers
  sw $s0, 0($sp) 
  sw $s1, 4($sp)
  sw $s2, 8($sp)
  sw $ra, 12($sp)



  add $s0, $a0, $zero #save head in s0
  add $s1, $a1, $zero #save buffer in s1
  add $s2, $a2, $zero #save i in s2

  lw $t0, 0($a0)
  bne $t0, $zero, if10 # if head->name ==0
  j return_obdd
  if10:
  addi $t0, $t0, -1
  bne $t0, $zero, if11
  add $t1, $s2, 1  
  sll $t1, $t1, 2
  add $t1, $t1, $s1
  sw $zero, 0($t1) #  buffer[i+1] = 0
  add $a0, $s1, $zero
  jal printbool
  j return_obdd

  if11:
  
  add $t1, $s2, 0
  sll $t1, $t1, 2
  add $t1, $t1, $s1
  lw $t0, 0($s0)
  sw $t0, 0($t1) # buffer[i] = head->name
  addi $t0, $zero, 1
  sw $t0, 4($t1) # buffer[i+1] = 1

  lw $a0, 4($s0) # init head, buffer and i
  add $a1, $s1, $zero
  add $a2, $s2, 2
  jal obdd_to_boolean # recursive call 1 

  add $t1, $s2, 1
  sll $t1, $t1, 2
  add $t1, $t1, $s1
  sw $zero, 0($t1) # buffer[i+1] = 0

  
  lw $a0, 8($s0) # init head, buffer and i
  add $a1, $s1, $zero
  add $a2, $s2, 2
  jal obdd_to_boolean # recursive call 1 
  
      
  return_obdd:

  lw $s0, 0($sp) 
  lw $s1, 4($sp)
  lw $s2, 8($sp)
  lw $ra, 12($sp)

  addi $sp, $sp, 16 # save save-registers

  jr  $ra                     #


#
# Some Parameters 
#
    .data
    buffer:     .space 40
# Testbelegungen um die OBDD's auszuwerten
    array1:     .word 'a',1,'b',0,'c',1,'d',0,0
    array2:     .word 'a',0,'b',1,'c',1,'d',0,0
    array3:     .word 'a',0,'b',0,'c',1,'d',0,0
    array4:     .word 'a',1,'b',1,'c',0,'d',1,0
# OBDD's zum Testen von evaluate und obdd_to_boolean
    obddx1:     .word 'a',obddx2,obddx3
    obddx2:     .word 'b',obddx4,obdd0
    obddx3:     .word 'c',obdd1,obdd0
    obddx4:     .word 'd',obdd0,obdd1

    obddy1:     .word 'c',obddy2,obdd0
    obddy2:     .word 'a',obddy3,obdd1
    obddy3:     .word 'b',obdd0,obdd1

    obdd1:      .word 1,0,0
    obdd0:      .word 0,0,0
# Strings/Characters fuer die Ausgabe auf der Konsole
#   false:      .byte '^',0
    false:      .byte 172,0
    true:       .byte ' ',' ',' ',0
    space:      .byte ' ',0
    newline:    .asciiz "\n"
    correct:    .asciiz "OBDD erfuellt die Belegung:"
    wrong:      .asciiz "OBDD erfuellt nicht die Belegung:"
    __out1:     .ascii  "########################################################\n"
    __out2:     .ascii  "   Teil 1: Werte den OBDD zu gegebener Belegung aus\n"
    __out3:     .asciiz "########################################################\n"
    __out4:     .ascii  "########################################################\n"
    __out5:     .ascii  "   Teil 2: OBDD zu boolschen Ausdruck\n"
    __out6:     .asciiz "########################################################\n"
    __out7:     .asciiz "\nTerme des OBDD:X\n"
    __out8:     .asciiz "\nTerme des OBDD:Y\n"

#
# main
#
    .text
    .globl main
main:
    addi    $sp, $sp, -4    #
    sw  $ra, 0($sp)         #returnadress auf den stack sichern

    la  $a0, __out1         #
    jal printstring         #konsolenausgabe

#Erste Teilaufgabe: Evalutaion des OBDD!
#obddx wird mit allen Belegungen 1-4 getestet   
    la  $a0, obddx1         #
    la  $a1, array1         #
    jal evaluate            #obddx mit belegung1
    move    $a0, $a1        #
    jal eval_to_string      #ausgabe auf der konsole
    la  $a0, obddx1         #
    la  $a1, array2         #
    jal evaluate            #obddx mit belegung2
    move    $a0, $a1        #
    jal eval_to_string      #ausgabe auf der konsole
    la  $a0, obddx1         #
    la  $a1, array3         #
    jal evaluate            #obddx mit belegung3
    move    $a0, $a1        #
    jal eval_to_string      #ausgabe auf der konsole
    la  $a0, obddx1         #
    la  $a1, array4         #
    jal evaluate            #obddx mit belegung4
    move    $a0, $a1        #
    jal eval_to_string      #ausgabe auf der konsole
    
#Zweite Teilaufgabe: OBDD in boolschen
#ausdruck umwandeln

    la  $a0, __out4     #
    jal printstring     #
    la  $a0, __out7     #
    jal printstring     #
    la  $a0, obddx1     #
    la  $a1, buffer     #
    addi    $a2, $0, 0  #
    jal obdd_to_boolean #obddx zu boolschen ausdruck umwandeln
    la  $a0, __out8     #
    jal printstring     #
    la  $a0, obddy1     #
    la  $a1, buffer     #
    addi    $a2, $0, 0  #
    jal obdd_to_boolean #obddy zu boolschen ausdruck umwandeln

main_end:
    
    lw  $ra, 0($sp)     # 
    addi    $sp, $sp, 4 # register/stack wiederherstellen
    jr  $ra             # programm beenden

#
# end main
#

#
#eval_to_string(belegung)
#

eval_to_string:
    addi    $sp, $sp, -8        #
    sw  $ra, 0($sp)             #
    sw  $a0, 4($sp)             #register auf stack sichern
    beq $v0, $0, ets_incorrect  #obdd als wahr oder falsch ausgewertet?
    la  $a0, correct            #ausgabe fuer ergebnis evaluate=1 vorbereiten
    jal printstring             #auf konsole ausgeben
    la  $a0, newline            #
    jal printstring             #zeilenumbruch
    j   ets_return              #

ets_incorrect:
    la  $a0, wrong              #ausgabe fuer ergebnis evaluate=0 vorbereiten
    jal printstring             #auf konsole ausgeben
    la  $a0, newline            #
    jal printstring             #zeilenumbruch

ets_return:
    lw  $a0, 4($sp)             #
    jal printbool               #belegung ausgeben
    la  $a0, newline            #
    jal printstring             #zeilenumbruch
    lw  $ra, 0($sp)             #
    addi    $sp, $sp, 8         #
    jr  $ra                     #register wiederherstellen und beenden

#
#printbool(&a[])
#   Ausgabe eines boolschen Ausdrucks der Form:
#   _ 
#   a = ^a
#

printbool:
    addi    $sp, $sp, -8
    sw  $ra, 0($sp)     #rücksprungaddresse
    sw  $s0, 4($sp)
    add $s0, $0, $a0    #array speichern
pb_start:
    lw  $t0, 0($s0)
    beq $t0, $0, pb_end     #abbruchbedingung
    lw  $t0, 4($s0)         #lade warheitswert
    bne $t0, $0, pb_literal #falls wahr nichts zu tun, sonst ^ als not einfügen
    la  $a0, false
    jal printstring
pb_literal:
    lw  $a0, 0($s0)         #lade literal
    jal print               #schreibe literal auf die console
    addi    $s0, $s0, 8     #array[i+2]
    j pb_start              #weiter durch array gehen
pb_end:
    la  $a0, newline
    jal printstring
    lw  $ra, 0($sp)
    lw  $s0, 4($sp)
    addi    $sp, $sp, 8
    jr  $ra

#
# die simpelsten Printfunktionen aller Zeiten
#
print:
    li  $v0, 11 #
    syscall     # Ausgabe eines characters
    jr  $ra     # 
printstring:
    li  $v0, 4  #
    syscall     # Ausgabe eines nullterminierten Strings
    jr  $ra     #
