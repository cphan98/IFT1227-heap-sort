# 20220019 Hoang-Thi-Thi Cynthia Phan
# 20254813 Razafindrakoto Nathan Riantsoa

# variables
.data
prompt: .asciiz "Enter the desired array length: "
address: .asciiz "Array base address: "
length: .asciiz "\nArray length: "

.data 0x10040000                # array starts at 0x10040000
array:

# functions and methods
.text
main:
    li      $v0, 4              # syscall 4: print string
    la      $a0, prompt     
    syscall                     # print prompt
    li	    $v0, 5              # syscall 5: read int
    syscall                     # $v0 = user's input
    blt     $v0, $0, main       # if $v0 < 0, then go to main
    jal     init                # jump to init and save position to $ra
    # TODO call fixHeap and heapSort
    li      $v0, 10             # syscall 10: exit
    syscall                     # terminate execution

init:
    add     $t0, $0, $v0        # $t0 = user's input = counter for loop
    add     $s0, $0, $t0        # $s0 = array length
    la      $s1, array          # $s1 = 0x10040000
loop:                           # loop to add values into array
    li      $v0, 5              # syscall 5: read int 
    syscall                     # $v0 = user's input
    sw      $v0, 0($s1)         # array[i] = user's input
    addi    $s1, $s1, 4         # go to next address
    addi    $t0, $t0, -1        # counter = counter - 1
    bgt     $t0, $0, loop       # if $t0 > 0 then go to loop
    la      $s1, array          # load back the beginning of the array into $s1 for future operations
    li      $v0, 4              # syscall 4: print string
    la      $a0, address     
    syscall                     # print address
    li      $v0, 34             # syscall 34: print int in hexa
    la      $a0, array
    syscall                     # print array base address
    li      $v0, 4              # syscall 4: print string
    la      $a0, length     
    syscall                     # print length
    li      $v0, 1              # syscall 1: print int
    add     $a0, $0, $s0     
    syscall                     # print array length
    jr      $ra                 # jump to $ra

swap:                           # 2 arguments: $a0 = i, $a1 = j
    mul     $t0, $a0, 4         # $t0 = position i in array
    add     $t1, $s1, $t0       # $t1 = array[i] address
    lw      $t2, 0($t1)         # $t2 = array[i]
    mul     $t0, $a1, 4         # $t0 = position j in array
    add     $t3, $s1, $t0       # $t3 = array[j] address
    lw      $t4, 0($t3)         # $t4 = array[j]
    sw      $t4, 0($t1)         # store array[j] into array[i] address
    sw      $t2, 0($t3)         # store array[i] into array[j] address
    jr      $ra                 # jump to $ra

getLeftChildIndex:              # 1 argument: $a0 = index
    mul     $t8, $a0, 2         # 2 * index
    addi    $t8, $t8, 1         # $t8 = 2 * index + 1
    jr      $ra                 # jump to $ra

getRightChildIndex:             # 1 argument: $a0 = index
    mul     $t9, $a0, 2         # 2 * index
    addi    $t9, $t9, 2         # $t9 = 2 * index + 2
    jr      $ra                 # jump to $ra

fixHeap:                        # 2 arguments: $a0 = rootIndex, $a1 = lastIndex
    # TODO
    # 1. remove root
    mul     $t0, $a0, 4         # $t0 = position rootIndex in array
    add     $t1, $s1, $t0       # $t1 = array[rootIndex] address
    lw      $s2, 0($t1)         # $s2 = array[rootIndex] = rootValue
    # 2. promote children while they are larger than the root
    add     $s3, $0, $a0        # $s3 = index
    addi    $s4, $0, 1          # $s4 = more = 1
while:
    bne     $s4, 1, done        # if $s4 != 1 then go to done
    add     $a0, $0, $s3        # argument 0 : $a0 = index
    la      $t7, ($ra)          # save previous $ra before jal
    jal     getLeftChildIndex   # jump to getLeftChildIndex and save position to $ra
    add     $t3, $t8, $0        # $t3 = childIndex, and it is initially leftChildIndex
    bgt     $t3, $a1, elseFinal # if $t8 > $a1 then go directly to elseFinal
    la	    $t7, ($ra)		 # save previous $ra before jal
    jal     getRightChildIndex  # jump to getRightChildIndex and save position to $ra
    ble     $t9, $a1, ifOne     # if $t9 <= $a1 then go to ifOne
    j       lastIf		 # jump directly to lastIf if $t9 > $a1
    
    # Use right child instead if it is larger
ifOne:
    mul     $t9, $t9, 4         # multiply $t9 (which is rightChildIndex) by 4 for array positioning
    add     $s7, $t9, $s1       # $s7 will be the adress of array[rightChildIndex]
    lw      $s6, 0($s7)	      	 # we load the value of array[rightChildIndex] into $s6
    mul     $t3, $t3, 4         # multiply $t9 (which is leftChildIndex) by 4 for array positioning
    add     $s7, $t3, $s1       # $s7 will be the adress of array[childIndex]
    lw      $s5, 0($s7)         # we load the value of array[childIndex] into $s5
    bgt     $s6, $s5, ifTwo     # the second conditional statement will then be verified if $s6 > $s5
    j       lastIf              # otherwise we jump directly to lastIf
ifTwo:
    div     $t9, $t9, 4         # we divide back $t9 by 4 to get its initial value
    add     $t3, $t9, $0        # we put $t9 into $t3. Now, childIndex becomes rightChildIndex
    j       lastIf              # we jump to lastIf after that
    
lastIf:
    mul     $t3, $t3, 4         # now that we have childIndex, we multiply by 4 for array positioning
    add     $s7, $t3, $s1       # we store the adress of array[childIndex] into $s7
    lw      $s6, 0($s7)         # we store the value of array[childIndex] into $s6
    bgt     $s6, $s2, lastThen  # $s2 is rootValue. if array[childIndex] > rootValue then jump to lastThen
    j       elseFinal           # otherwise we jump directly to elseFinal
    
lastThen:
    # Promote  child
    mul     $s3, $s3, 4         # s3 = index, multiply by 4 for array positioning
    add     $s7, $s3, $s1       # we store the adress of array[index] into $s7
    sw      $s6, 0($s7)         # we write the value of $s6 (which is array[childIndex]) into array[index]
    div     $t3, $t3, 4         # we multiplied $t3 by 4 earlier so we divide it back by 4
    add     $s3, $t3, $0        # $s3 takes the value of $t3. index = childIndex
    j       while
elseFinal:
    addi    $s4, $0, -1         # more = 0 = false
    j       while               # jump to while
    # 3. store root value in vacant slot
done:
    mul     $t0, $s3, 4         # $t0 = position index in array
    add     $t1, $s1, $t0       # $t1 = array[index] address
    sw      $s2, 0($t1)         # array[index] = rootValue
    la      $ra, ($t7)
    jr      $ra                 # jump to $ra

heapSort:                       # 2 arguments: $a0 = array, $a1 = lengthß
    # TODO
