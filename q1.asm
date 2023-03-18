# 20220019 Hoang-Thi-Thi Cynthia Phan
# 20254813 Razafindrakoto Nathan Riantsoa

# variables
.data
prompt: .asciiz "Enter the desired array length: "
address: .asciiz "Array base address: "
length: .asciiz "\nArray length: "
leftChild: .asciiz "\nLeft child index: "
rightChild: .asciiz "\nRight child index: "

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
    addi    $a0, $0, 0          # argument 0 = i = 0
    addi    $a1, $0, 1          # argument 1 = j = 1
    jal     swap                # jump to swap and save position to $ra
    addi    $a0, $0, 0          # argument 0 = index = 0
    jal     getLeftChildIndex   # jump to getLeftChildIndex and save position to $ra
    addi    $a0, $0, 0          # argument 0 = index = 0
    jal     getRightChildIndex  # jump to getRightChildIndex and save position to $ra
    li      $v0, 10             # syscall 10: exit
    syscall                     # terminate execution

init:
    add     $t0, $0, $v0        # $t0 = user's input = counter for loop
    add     $s0, $0, $t0        # $s0 = array length
    la      $t1, array          # $t1 = 0x10040000
loop:                           # loop to add values into array
    li      $v0, 5              # syscall 5: read int 
    syscall                     # $v0 = user's input
    sw      $v0, 0($t1)         # array[i] = user's input
    addi    $t1, $t1, 4         # go to next address
    addi    $t0, $t0, -1        # counter = counter - 1
    bgt     $t0, $0, loop       # if $t0 > 0 then go to loop
    li      $v0, 4              # syscall 4: print string
    la      $a0, address     
    syscall                     # print address
    li      $v0, 34             # syscall 34: print int in hexa
    la      $a0, array
    syscall                     # print array address
    li      $v0, 4              # syscall 4: print string
    la      $a0, length     
    syscall                     # print length
    li      $v0, 1              # syscall 1: print int
    add     $a0, $0, $s0     
    syscall                     # print array length
    jr      $ra                 # jump to $ra

swap: 
    la      $t0, array
    mul     $t1, $a0, 4         # position i in array
    add     $t2, $t0, $t1       # array[i] address
    lw      $t3, 0($t2)         # array[i]
    mul     $t1, $a1, 4         # position j in array
    add     $t4, $t0, $t1       # array[j] address
    lw      $t5, 0($t4)         # array[j]
    sw      $t5, 0($t2)         # store array[j] into array[i] address
    sw      $t3, 0($t4)         # store array[i] into array[j] address
    jr      $ra                 # jump to $ra
    
getLeftChildIndex:
    mul     $t0, $a0, 2         # 2 * index
    addi    $t0, $t0, 1         # 2 * index + 1
    li      $v0, 4              # syscall 4: print string
    la      $a0, leftChild     
    syscall                     # print leftChihld
    li      $v0, 1              # syscall 1: print int
    add     $a0, $0, $t0     
    syscall                     # print left child index
    jr      $ra                 # jump to $ra
    
getRightChildIndex:
    mul     $t0, $a0, 2         # 2 * index
    addi    $t0, $t0, 2         # 2 * index + 2
    li      $v0, 4              # syscall 4: print string
    la      $a0, rightChild     
    syscall                     # print rightChild
    li      $v0, 1              # syscall 1: print int
    add     $a0, $0, $t0     
    syscall                     # print right child index
    jr      $ra                 # jump to $ra