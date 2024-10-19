.data
array: .space 20 #5*4
ln: .asciiz "\n"
.text
j main

#void selectionSort(int array[], int n) {
selectionSort:
    #as callee
    addi $sp,$sp,-4
    sw $s0,0($sp)
    #for (int i=0; i<n-1; i++) {  t0 for i, t1 for j
    li $t0,0 #i=0
    i_loop_sort:
        bge $t0,$a1,i_loop_sort_end #i<n-1
        #int min_idx = i;
        move $t2,$t0 #t2 for min_idx

        #j=i+1
        move $t1,$t0
        addi $t1,$t1,1
        #for (int j=i+1; j<n; j++) {
        j_loop_sort:
            bge $t1,$a1,j_loop_sort_end #j<n
            #if (array[j] < array[min_idx]) min_idx = j;
            #array[j]
            sll $t3,$t1,2
            add $t3,$t3,$a0
            lw $t3,0($t3)

            #array[min_idx]
            sll $t4,$t2,2
            add $t4,$t4,$a0
            lw $t4,0($t4)

            bge $t3,$t4,if_not ##if (array[j] < array[min_idx])
            move $t2,$t1 #min_idx = j

            if_not:
            addi $t1,$t1,1 #j++
            j j_loop_sort
        j_loop_sort_end:
        #int temp = array[min_idx]; #t0 for i, t1 for temp, t2 for min_idx
        sll $t3,$t2,2
        add $t3,$a0,$t3 #&array[min_idx]
        lw $t1,0($t3)

        #array[min_idx] = array[i]; #t0 for i, t1 for temp, t2 for min_idx, t3 for &array[min_idx],
        sll $t4,$t0,2
        add $t4,$t4,$a0 #&array[i]
        lw $t5,0($t4) #value of array[i]
        sw $t5,0($t3)

        #array[i] = temp; #t0 for i, t1 for temp, t2 for min_idx, t4 for &array[i]
        sw $t1,0($t4)

        #i++
        addi $t0,$t0,1
        j i_loop_sort
    i_loop_sort_end:
        #as callee
        lw $s0,0($sp)
        addi $sp,$sp,4
        jr $ra


#int main()
main:
#int array[5];
    la $s0,array
#for (int i = 0; i < 5; i++) scanf("%d", &array[i]);
    li $t0,0 #t0 for i
    loop_main:
        li $t1,5
        bge $t0,$t1,loop_main_end

        #scanf("%d", &array[i])
        sll $t1,$t0,2
        add $t1,$t1,$s0

        li $v0,5
        syscall
        sw $v0,0($t1)

        #i++
        addi $t0,$t0,1
        j loop_main
    loop_main_end:
        #selectionSort(array, 5);
        move $a0,$s0
        addi $a1,$zero,5
        jal selectionSort

    #for (int i = 0; i < 5; i++) {
    li $t0,0 #i=0
    print_loop:
        li $t1,5
        bge $t0,$t1,print_loop_end
        #printf("%d\n", array[i]);
        sll $t1,$t0,2
        add $t1,$t1,$s0 #&array[i]

        lw $a0,0($t1)
        li $v0,1
        syscall #print value of array[i]

        la $a0,ln
        li $v0,4
        syscall #print \n

        addi $t0,$t0,1 #i++
        j print_loop
    print_loop_end:
        li $v0,10
        syscall