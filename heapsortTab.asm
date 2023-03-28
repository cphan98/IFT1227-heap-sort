# 20220019 Hoang-Thi-Thi Cynthia
# 20254813 Razafindrakoto Nathan Riantsoa

# variables
.data
prompt: .asciiz "Enter the desired array length: "
address: .asciiz "Array base address: "
length: .asciiz "\nArray length: "

.data 0x10040000                                    # array starts at 0x10040000
array:

# functions and methods
.text
main:
    li      $v0,    4                               # syscall 4: print string
    la      $a0,    prompt
    syscall                                         # print "Enter the desired array length: "
    li      $v0,    5                               # syscall 5: read int
    syscall                                         # $v0 = user's input = array lenght
    blt     $v0,    $0,     main                    # if $v0 < 0 (array length is neg), then go to main
    jal     init                                    # else, jump to init and save position to $ra

# TODO