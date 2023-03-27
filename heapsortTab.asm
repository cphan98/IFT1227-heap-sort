# 20220019 Hoang-Thi-Thi Cynthia
# 20254813 Razafindrakoto Nathan Riantsoa

# variables
.data
prompt: .asciiz "Enter the desired array length: "
address: .asciiz "Array base address: "
length: .asciiz "\nArray length: "

.data 0x10040000			# array starts at 0x10040000
array:

# functions and methods
.text
main:
	li	$v0, 4			        # syscall 4: print string
	la	$a0, prompt
	syscall 			        # print "Enter the desired array length: "
	li	$v0, 5			        # syscall 5: read int
	syscall				        # $v0 = user's input = array length
	blt	$v0, $0, main	        # if $v0 < 0 (array length is neg), then go to main
	jal	init			        # else, jump to init and save position to $ra
	la	$a0, array		        # arg 0 = $a0 = array address base
	add	$a1, $0, $v0	        # arg 1 = $a1 = array length		
	jal	heapsort		        # jump to init and save position to $ra
	li	$v0, 10			        # syscall 10: exit
	syscall 			        # terminate execution

init:
	add	    $t0, $0, $v0	    # $t0 = array length = counter for loop
	add	    $s0, $0, $t0	    # $s0 = array length
	la	    $s1, array		    # $s1 = 0x10040000
initLoop:
	li	    $v0, 5			    # syscall 5: read int
	syscall				        # $v0 = user's input = element of array
	sw	    $v0, 0($s1)		    # store $v0 into array[i] address
	addi	$s1, $s1, 4	        # increment by 4 to go to next array[i] address
	addi	$t0, $t0, -1        # $t0 = counter - 1
	bgt	    $t0, $0, loop	    # if $t0 > 0 (counter is pos) then go to loop
	la	    $s1, array		    # reset $s1 = 0x10040000
	li	    $v0, 4			    # syscall 4: print string
	la	    $a0, address
	syscall				        # print "Array base address: "
	li	    $v0, 34			    # syscall 34: print int in hexadecimal
	la	    $a0, array
	syscall				        # print 0x10040000
	li	    $v0, 4			    # syscall 4: print string
	la	    $a0, length
	syscall				        # print "\nArray length: "
	li	    $v0, 1		    	# syscall 1: print int
	add	    $a0, $0, $s0
	syscall				        # print $s0 = array length
	jr	    $ra			        # jump to $ra

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
    bgt     $t8, $a1, else      # if $t8 > $a1 then go to else
    jal     getRightChildIndex  # jump to getRightChildIndex and save position to $ra
    bgt     $t9, $a1, if        # if $t9 > $a1 then go to if
    mul     $t0, $t9, 4         # $t0 = position rightChildIndex in array
    add     $t1, $s1, $t0       # $t1 = array[rightChildIndex] address
    lw      $t2, 0($t1)         # $t2 = array[rightChildIndex]
    mul     $t0, $t8, 4         # $t0 = position childIndex
    add     $t1, $s1, $t0       # $t1 = array[childIndex] address
    lw      $t3, 0($t1)         # $t3 = array[childIndex]
    ble     $t2, $t3, if        # if $t2 <= $t3 then go to if
    add     $t8, $0, $t9        # childIndex = rightChildIndex
if:
    ble     $t3, $s2, else      # if $t3 <= $s2 then go to else
    mul     $t0, $s3, 4         # $t0 = position index in array
    add     $t1, $s1, $t0       # $t1 = array[index] address
    sw      $t3, 0($t1)         # array[index] = array[childIndex]
    add     $s3, $0, $t8        # index = childIndex
    j       done                # jump to done
else:
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