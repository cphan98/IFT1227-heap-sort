# 20220019 Hoang-Thi-Thi Cynthia Phan
# 20254813 Razafindrakoto Nathan Riantsoa

# variables
.data
prompt: .asciiz "Enter the desired array length: "
address: .asciiz "Array base address: "
length: .asciiz "\nArray length: "

.data 0x10040000            # array starts at 0x10040000
array:

# functions and methods
.text
main:
    li      $v0, 4          # syscall 4: print string
    la      $a0, prompt     
    syscall                 # print prompt
    li	    $v0, 5	        # syscall 5: read int
    syscall                 # $v0 = user's input
    add     $t0, $0, $v0    # $t0 = user's input = counter for loop
    add     $s0, $0, $t0    # $s0 = array length
    # TODO call other methods/functions

init:
    la      $t1, array      # $t1 = 0x10040000
loop:                       # loop to add values into array
    li      $v0, 5          # syscall 5: read int 
    syscall                 # $v0 = user's input
    sw		$v0, 0($t1)		# array[i] = user's input
    addi    $t1, $t1, 4     # go to next address
    addi    $t0, $t0, -1    # counter = counter - 1
    bgt     $t0, $0, loop	# if $t0 > 0 then go to loop
    li      $v0, 4          # syscall 4: print string
    la      $a0, address     
    syscall                 # print address
    li      $v0, 34         # syscall 34: print int in hexa
    la      $a0, array
    syscall                 # print array address
    li      $v0, 4          # syscall 4: print string
    la      $a0, length     
    syscall                 # print length
    li      $v0, 1          # syscall 1: print int
    add     $a0, $0, $s0     
    syscall                 # print array length

# swap:
#     # TODO
# getLeftChildIndex:
#     # TODO
# getRightChildIndex:
    # TODO