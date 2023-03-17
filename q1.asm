# 20220019 Hoang-Thi-Thi Cynthia Phan
# 20254813 Razafindrakoto Nathan Riantsoa

# variables
.data
prompt: .asciiz "Enter the desired array length: "

# functions and methods
.text
    # prompt user to enter length n
    li      $v0, 4          # $v0 = 4
    la      $a0, prompt     # $a0 = prompt
    syscall                 # print prompt

    # get user's desired length
    li	    $v0, 5	        # $v0 = 5
    syscall                 # $v0 = user's input

    # calculate number of bytes to allocate to array
    mul     $t0, $v0, 4     # $t0 = $v0 * 4

    # allocate heap memory beginning at 0x10040000
    li      $v0, 9          # $v0 = 9
    move    $a0, $t0        # $a0 = $t0
    syscall                 # allocate $a0 bytes to array

# TO DO
main:
init:
swap:
getLeftChildIndex:
getRightChildIndex: