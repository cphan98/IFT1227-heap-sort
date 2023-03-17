# 20220019 Hoang-Thi-Thi Cynthia Phan
# 20254813 Razafindrakoto Nathan Riantsoa

# variables
.data
prompt: .asciiz "Enter the desired array length: "

# functions and methods
.text
main:
    li      $v0, 4          # syscall 4: print string
    la      $a0, prompt     
    syscall                 # print prompt
    li	    $v0, 5	        # syscall 5: read int
    syscall                 # $v0 = user's input
    move    $v0, $s0        # $s0 = $v0 = counter for loop

init:
    la      $s1, 0x10040000 # $s1 = 0x10040000
loop:                       # loop to add values into array
    li      $v0, 5          # syscall 5: read int 
    syscall                 # $v0 = user's input
    sw		$v0, 0($s1)		# array[i] = user's input
    addi    $s1, $s1, 4     # go to next address
    addi    $s0, $s0, -1    # counter = counter - 1
    bgt     $s0, $0, loop	# if $s0 > 0 then go to loop

# swap:
#     # TODO
# getLeftChildIndex:
#     # TODO
# getRightChildIndex:
    # TODO