# 20220019 Hoang-Thi-Thi Cynthia Phan
# 20254813 Razafindrakoto Nathan Riantsoa

# variables
.data
prompt: .asciiz "Enter the desired array length: "
array: .data 0x10040000     # array data starts at 0x10040000

# functions and methods
.text
main:
    # prompt user to enter length n
    li      $v0, 4          # $v0 = 4
    la      $a0, prompt     # $a0 = prompt
    syscall                 # print prompt

    # read user's input
    li	    $v0, 5	        # $v0 = 5
    syscall                 # $v0 = user's input

    # store user's input into $s0
    move    $v0, $s0        # $s0 = $v0

init:
    # load array base address
    la      $s1, array
    
# swap:
#     # TODO
# getLeftChildIndex:
#     # TODO
# getRightChildIndex:
    # TODO