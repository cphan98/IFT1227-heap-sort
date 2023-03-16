# 20220019 Hoang-Thi-Thi Cynthia Phan
# 20254813 Razafindrakoto Nathan Riantsoa

# initialize array of n elements

.data
    prompt: .asciiz "Enter the desired length of the array: "

.text
    # prompt user to enter length n
    li  $v0, 4          # $v0 = 4
    la  $a0, prompt     # $a0 = prompt
    syscall

    # get user's desired length n
    li		$v0, 5	    # $v0 = 5
    syscall

    # store user's input into $s0
    move 	$t0, $v0	# $t0 = $v0