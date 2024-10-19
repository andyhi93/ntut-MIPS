.data
space: .asciiz " "
ln: .asciiz "\n"
A:  .space 36 #3*3*4
A1: .space 36 #3*3*4
A2: .space 36 #3*3*4
.text
j main

#void inputMatrix(int A[3][3]) {
input:
#for (int i = 0; i < 3; i++) { t0 for i, t1 for j
    li $t0,0 #int i = 0
    input_i_loop:
        li $t2,3
        bge $t0,$t2,input_i_loop_end #i < 3
        #for (int j = 0; j < 3; j++) {
        li $t1,0 #j=0
        input_j_loop:
            li $t2,3
            bge $t1,$t2,input_j_loop_end #j<3

            #scanf("%d", &A[i][j]);
            sll $t2,$t0,2
            li $t3,3
            mul $t2,$t2,$t3 #A[i]
            sll $t3,$t1,2 #[j]
            add $t2,$t2,$t3
            add $t2,$t2,$a0 #&A[i][j]

            li $v0,5 #scanf
            syscall
            sw $v0,0($t2)

            addi $t1,$t1,1
            j input_j_loop
        input_j_loop_end:

        addi $t0,$t0,1 #i++
        j input_i_loop
    input_i_loop_end:
        jr $ra

#void transposeMatrixA1(int A[3][3], int T[3][3], int size) {
transposeMatrixA1:
    #for (int i = 0; i < size; i++) { t0 for i, t1 for j
    li $t0,0 #int i = 0
    transposeMatrixA1_i_loop:
        bge $t0,$a2,transposeMatrixA1_i_loop_end #i < 3
        #for (int j = 0; j < size; j++) {
        li $t1,0 #j=0
        transposeMatrixA1_j_loop:
            bge $t1,$a2,transposeMatrixA1_j_loop_end #j<3

            #T[j][i] = A[i][j];
            sll $t2,$t0,2
            li $t3,3
            mul $t2,$t2,$t3 #A[i]
            sll $t3,$t1,2 #[j]
            add $t2,$t2,$t3
            add $t2,$t2,$a0 #&A[i][j]
            lw $t2,0($t2) #value of A[i][j]

            sll $t3,$t1,2
            li $t4,3
            mul $t3,$t3,$t4 #T[j]
            sll $t4,$t0,2
            add $t3,$t3,$t4 #[i][j]
            add $t3,$t3,$a1 #&T[j][i]

            sw $t2,0($t3)

            addi $t1,$t1,1
            j transposeMatrixA1_j_loop
        transposeMatrixA1_j_loop_end:

        addi $t0,$t0,1 #i++
        j transposeMatrixA1_i_loop
    transposeMatrixA1_i_loop_end:
        jr $ra

#void transposeMatrixA2(int *B, int *T, int size) {
transposeMatrixA2:
    #int *ptrB, *ptrT, i;
    #for (ptrB = B, ptrT = T, i = 1; ptrB < (B + (size * size)); ptrB++) {
    #t0 for ptrB, t1 for ptrT, t2 for i
    move $t0,$a0
    move $t1,$a1
    li $t2,1
    transposeMatrixA2_loop:
        li $t3,36 #3*3*4=36
        add $t3,$a0,$t3
        bge $t0,$t3,transposeMatrixA2_loop_end #ptrB < (B + (size * size))

        #*ptrT = *ptrB;
        lw $t3,0($t0)
        sw $t3,0($t1)

        #if (i < size) {
        transposeMatrixA2_if:
            li $t3,3
            bge $t2,$t3,transposeMatrixA2_else

            #ptrT += size;
            addi $t1,$t1,12 #3*4
            #i++;
            addi $t2,$t2,1
            j transposeMatrixA2_if_end
        #} else {
        transposeMatrixA2_else:
            #ptrT -= (size * (size - 1) - 1); #(3*(3-1)-1)*4=20
            addi $t1,$t1,-20
            #i = 1;
            li $t2,1
        transposeMatrixA2_if_end:
        addi $t0,$t0,4 #ptrB++
        j transposeMatrixA2_loop
    transposeMatrixA2_loop_end:
        jr $ra
output:
    #void outputMatrix(int A[3][3]) {
    li $t0,0 #int i = 0
    #for (int i = 0; i < 3; i++) { t0 for i, t1 for j
    output_i_loop:
        li $t2,3
        bge $t0,$t2,output_i_loop_end #i < 3
        #for (int j = 0; j < 3; j++) {
        li $t1,0 #j=0
        output_j_loop:
            li $t2,3
            bge $t1,$t2,output_j_loop_end #j<3

            #printf("%d ", A[i][j]);
            sll $t2,$t0,2
            li $t3,3
            mul $t2,$t2,$t3 #A[i]
            sll $t3,$t1,2
            add $t2,$t2,$t3 #A[i][j]
            add $t2,$t2,$a0 #&A[i][j]

            li $v0,1 #print int
            addi $sp,$sp,-4
            sw $a0,0($sp)
            lw $a0,0($t2) #value of A[i][j]
            syscall

            li $v0,4 #print string
            la $a0,space
            syscall

            lw $a0,0($sp)
            addi $sp,$sp,4

            addi $t1,$t1,1 #j++
            j output_j_loop
        output_j_loop_end:

        #printf("\n");
        addi $sp,$sp,-4
        sw $a0,0($sp)

        li $v0,4 #print string
        la $a0,ln
        syscall

        lw $a0,0($sp)
        addi $sp,$sp,4

        addi $t0,$t0,1 #i++
        j output_i_loop
    output_i_loop_end:
        jr $ra

#int main() {
main:
    #int A[3][3];
    la $s0,A
    #int transposeOfA1[3][3];
    la $s1,A1
    #int transposeOfA2[3][3];
    la $s2,A2

    #inputMatrix(A);
    move $a0,$s0
    jal input

    move $a0,$s0
    move $a1,$s1
    addi $a2,$zero,3
    #transposeMatrixA1(A, transposeOfA1, 3);
    jal transposeMatrixA1

    #int *ptrA = &A[0][0];
    move $a0,$s0
    #int *ptrTA2 = &transposeOfA2[0][0];
    move $a1,$s2
    addi $a2,$zero,3
    #transposeMatrixA2(ptrA, ptrTA2, 3);
    jal transposeMatrixA2

    #outputMatrix(transposeOfA1);
    move $a0,$s1
    jal output
    #outputMatrix(transposeOfA2);
    move $a0,$s2
    jal output

    li $v0,10
    syscall
