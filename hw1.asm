.data
underweight: .asciiz "underweight\n"
overweight: .asciiz "overweight\n"
ln: .asciiz "\n"

.text
.globl main

main:
loop:
    li $v0,5 #syscall 5 = read integer
    syscall
    move $s0,$v0 #s0=height

    beq $s0,-1,exit

    li $v0,5
    syscall
    move $s1,$v0 #s1=weight

    move $a0,$s0 #function value
    move $a1,$s1
    jal calculateBMI #呼叫 calculateBMI，結果在 $v0
    move $s2,$v0 #a0=bmi=printResult(bmi)
    move $a0,$s2
    jal printResult
    j loop

calculateBMI:
    # a0: height, a1: weight
    # bmi = (weight * 10000) / (height * height)
    addi $sp,$sp,-8
    sw $s0,0($sp) # Save s0
    sw $s1,4($sp) # Save s1

    mul $t0,$a1,10000
    mul $t1,$a0,$a0
    div $t0,$t1
    mflo $v0 #商從lo取出存到v0,v0用於儲存函數返回值 v0=bmi

    lw $s0,0($sp)
    lw $s1,4($sp)
    addi $sp,$sp,8
    jr $ra #jump return register adress
printResult:
    #a0=bmi

    addi $sp,$sp,-4
    sw $s2,0($sp)

    ble $a0,17,printUnderweight
    bge $a0,25,printOverweight
    j printElse
end_print:
    lw $s0,0($sp)
    addi,$sp,$sp,4
    jr $ra
printElse:
    li $v0,1
    syscall
    la $a0,ln
    li $v0,4
    syscall
    j end_print
printUnderweight:
    li $v0, 4   # syscall 4 = print string
    la $a0, underweight # 載入 "underweight" 字串
    syscall
    j end_print
printOverweight:
    li $v0,4
    la $a0,overweight
    syscall
    j end_print
exit:
    li $v0, 10  # syscall 10 = exit
    syscall