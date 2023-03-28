# 20220019 Hoang-Thi-Thi Cynthia
# 20254813 Razafindrakoto Nathan Riantsoa

# variables
.data
prompt: .asciiz "Enter the desired array length: "
address: .asciiz "Array base address: "
length: .asciiz "\nArray length: "

.data 0x10040000                                        # array starts at 0x10040000
array:

# functions and methods
# $s0 = array length
# $s1 = 0x10040000
.text
main:
    li      $v0,                4                       # syscall 4: print string
    la      $a0,                prompt
    syscall                                             # print "Enter the desired array length: "
    li      $v0,                5                       # syscall 5: read int
    syscall                                             # $v0 = user's input = array lenght
    blt     $v0,                $0,         main        # if $v0 < 0 (array length is neg), then go to main
    jal     init                                        # else, jump to init and save position to $ra
    la      $a0,                array                   # arg 0 = $a0 = 0x10040000
    add     $a1,                $0,         $s0         # arg 1 = $a1 = array length
    jal     heapSort                                    # jump to heapSort and save position to $ra

# TODO

init:
    add     $t0,                $0,         $v0         # $t0 = array length = counter for loop
    add     $s0,                $0,         $t0         # $s0 = array length
    la      $s1,                array                   # $s1 = 0x10040000
initLoop:
    li      $v0,                5                       # syscall 5: read int
    syscall                                             # $v0 = user's input
    sw      $v0,                0($s1)                  # store $v0 = user's input into $s1 address = array[i] address
    addi    $s1,                $s1,        4           # array[i] address + 4 = next array[i] address
    addi    $t0,                $t0,        -1          # $t0 = counter - 1
    bgt     $t0,                $0,         initLoop    # if $t0 > 0 (counter is pos), then go to initLoop
    la      $s1,                array                   # reset $s1 = 0x10040000
    li      $v0,                4                       # syscall 4: print string
    la      $a0,                address
    syscall                                             # print "Array base address: "
    li      $v0,                34                      # syscall 34: print int in hexadecimal
    la      $a0,                array
    syscall                                             # print 0x10040000
    li      $v0,                4                       # syscall 4: print string
    la      $a0,                length
    syscall                                             # print "\nArray length: "
    li      $v0,                1                       # syscall 1: print int
    add     $a0,                $0,         $s0
    syscall                                             # print $s0 = array length
    jr      $ra                                         # jump to $ra

# 1 arg: $a0 = index
getLeftChildIndex:
    mul     $s4,                $a0,        2           # $s4 = 2 * index
    addi    $s4,                $s4,        1           # $s4 = 2 * index + 1
    jr      $ra                                         # jump to $ra

# 2 args: $a0 = rootIndex, $a1 = lastIndex
fixHeap:
    addi    $sp,                $sp,        -4          # make spce in stack
    sw      $ra,                0($sp)                  # add $ra value to stack
                                                        # remove root
    mul     $s2,                $a0,        4           # $s2 = rootIndex position in array
    add     $s2,                $s2,        $s1         # $s2 = array[rootIndex] address
    lw      $s2,                0($s2)                  # $s2 = array[rootIndex] value = rootValue
                                                        # promote children while they are larger than the root
    add     $s3,                $0,         $a0         # $s3 = rootIndex = index
    addi    $t2,                $0,         1           # $t2 = 1 = true = more
while:
    bne     $t2,                1,          done        # if $t2 != 1 (more = false), then go to done
    add     $a0,                $0,         $3          # arg 0 = $a0 = index
    jal     getLeftChildIndex                           # jump to getLeftChildIndex and save position to $ra
    add     $s4,                $a1,        else        # if $s4 > $a1 (childIndex > lastIndex), then go to else
                                                        # use right child instead if it is larger
    jal     getRightChildIndex                          # jump to getRightChildIndex and save position to $ra

# TODO

# 2 args: $a0 = array base address, $a1 = array length
heapSort:
    addi    $sp,                $sp,        -4          # make space in stack
    sw      $ra,                0($sp)                  # add $ra value to stack
    addi    $t0,                $s0,        -1          # $t0 = n = array.length - 1
    addi    $t1,                $t0,        -1          # $t1 = n - 1
    div     $t1,                $t1,        2           # $t1 = i = (n - 1)/2
forLoop:
    bltz    $t1,                whileLoop               # if $t1 > 0 (i is neg), then go to whileLoop
    add     $a0,                $0,         $t1         # arg 0 = $a0 = i
    add     $a1,                $0,         $t0         # arg 1 = $a1 = n
    jal     fixHeap                                     # jump to fixHeap and save position to $ra

# TODO