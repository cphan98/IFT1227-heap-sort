# 20220019 Hoang-Thi-Thi Cynthia Phan
# 20254813 Razafindrakoto Nathan Riantsoa

# variables
.data
    prompt: .asciiz "Entrer the desired length of the array: "
    n:

# functions and methods
.text
    # prompt user to enter length n
    li  $v0, 4          # $v0 = 4
    la  $a0, prompt     # $a0 = prompt
    syscall             # print prompt

    # get user's desired length n
    li		$v0, 5	    # $v0 = 5
    syscall             # $v0 = n (user's input)

    # store user's input into n
    move    $v0, n      # n = $v0

    # TO DO
    main:
    init:
    swap:
    getLeftChildIndex:
    getRightChildIndex: