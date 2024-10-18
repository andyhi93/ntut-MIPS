.data
x:  .space 400
comma: .asciiz ","

.text
j main
#void print(int size, int *x) {
print:
    #as callee
    addi $sp,$sp,-8
    sw $s0,0($sp)
    sw $s1,4($sp)
    #for (int i=0; i<size; i++) {
    #$t0=i=0
    add $t0,$zero,$zero
    print_loop:
        #i<size
        bge $t0,$a0,print_loop_end
        #printf("%d,",x[i]);
        sll $t1,$t0,2
        add $t1,$t1,$a1
        lw $s0,0($t1) #value of x[i]

        addi $sp,$sp,-4
        sw $a0,0($sp)

        li $v0,1 #print int
        add $a0,$s0,$zero
        syscall

        #print comma
        li $v0,4 #print string
        la $a0,comma
        syscall

        lw $a0,0($sp)
        addi $sp,$sp,4
        #i++
        addi $t0,$t0,1
        j print_loop
    print_loop_end:
        lw $s0,0($sp)
        lw $s1,4($sp)
        addi $sp,$sp,8
        jr $ra

fact: #a0 is n, a1 is &x
    #as caller func
    addi $sp,$sp,-8
    sw $s0,0($sp)
    sw $s1,4($sp)
    #int t=0;
    #if (n < 2) {
    li $t0,2
    bge $a0,$t0,fact_else #else
    #   x[n] = t = 1;
    li $v0,1 #v0 is return value
    sll $t0,$a0,2
    add $t0,$t0,$a1
    sw $v0,0($t0)
    #return t;
    #as callee
    lw $s0,0($sp)
    lw $s1,4($sp)
    addi $sp,$sp,8
    jr $ra
fact_else:
    #as caller
    addi $sp,$sp,-12
    sw $a0,0($sp)
    sw $a1,4($sp)
    sw $ra,8($sp)
    #x[n] = t = fact(n - 1, x) + fact(n - 2, x);
    #fact(n - 1, x)
    addi $a0,$a0,-1
    jal fact
    add $s0,$zero,$v0 #s0 is fact(n - 1, x)

    #fact(n - 2, x)
    addi $a0,$a0,-1
    jal fact
    add $s1,$zero,$v0 #s1 is fact(n - 2, x)
    #return t;
    add $v0,$s0,$s1

    #as caller
    lw $a0,0($sp)
    lw $a1,4($sp)
    lw $ra,8($sp)
    addi $sp,$sp,12
    #x[n]=t
    sll $t0,$a0,2
    add $t0,$a1,$t0
    sw $v0,0($t0)
    #as callee
    lw $s0,0($sp)
    lw $s1,4($sp)
    addi $sp,$sp,8

    jr $ra
main:
    #int x[100];
    la $s0,x #s0 is &x
    #x[0]=1;
    addi $t0,$zero,1
    sw $t0,0($s0)
    #for (int i=1; i<100; i++) x[i]=0;
    addi $t0,$zero,1
    #$t0 is i
    main_loop:
        bge $t0,100,main_loop_end
        sll $t1,$t0,2
        add $t1,$t1,$s0
        sw  $zero,0($t1)
        #i++
        addi $t0,$t0,1
        j main_loop
    main_loop_end:
        #scanf("%d", &n);
        addi $v0,$zero,5
        syscall
        add $s1,$v0,$zero #s1 is n
        #fact(n, x);
        add $a0,$s1,$zero
        add $a1,$zero,$s0

        addi $sp,$sp,-8
        sw $a0,0($sp)
        sw $a1,4($sp)

        jal fact

        lw $a0,0($sp)
        lw $a1,4($sp)
        addi $sp,$sp,8
        #print(n, x);
        jal print


        #end
        li $v0,10
        syscall