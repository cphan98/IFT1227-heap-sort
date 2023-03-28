# 20220019 Hoang-Thi-Thi Cynthia
# 20254813 Razafindrakoto Nathan Riantsoa

# variables
.data
prompt: .asciiz "Enter the desired array length: "
address: .asciiz "Array base address: "
length: .asciiz "\nArray length: "

.data 0x10040000			        # array starts at 0x10040000
array:

# functions and methods
.text
main:
	li	    $v0, 4			        # syscall 4: print string
	la	    $a0, prompt
	syscall 			            # print "Enter the desired array length: "
	li	    $v0, 5			        # syscall 5: read int
	syscall				            # $v0 = user's input = array length
	blt	    $v0, $0, main   	    # if $v0 < 0 (array length is neg), then go to main
	jal	init			            # else, jump to init and save position to $ra
	la	    $a0, array		        # arg 0 = $a0 = array address base
	add	    $a1, $0, $v0	        # arg 1 = $a1 = array length		
	jal	heapSort		            # jump to init and save position to $ra
	li	    $v0, 10			        # syscall 10: exit
	syscall 			            # terminate execution

init:
	add	    $t0, $0, $v0	        # $t0 = array length = counter for loop
	add	    $s0, $0, $t0	        # $s0 = array length
	la	    $s1, array		        # $s1 = 0x10040000
initLoop:
	li	    $v0, 5			        # syscall 5: read int
	syscall				            # $v0 = user's input = element of array
	sw	    $v0, 0($s1)		        # store $v0 into array[i] address
	addi	$s1, $s1, 4	            # increment by 4 to go to next array[i] address
	addi	$t0, $t0, -1            # $t0 = counter - 1
	bgt	    $t0, $0, initLoop	    # if $t0 > 0 (counter is pos) then go to initLoop
	la	    $s1, array		        # reset $s1 = 0x10040000
	li	    $v0, 4			        # syscall 4: print string
	la	    $a0, address
	syscall				            # print "Array base address: "
	li	    $v0, 34			        # syscall 34: print int in hexadecimal
	la	    $a0, array
	syscall				            # print 0x10040000
	li	    $v0, 4			        # syscall 4: print string
	la	    $a0, length
	syscall				            # print "\nArray length: "
	li	    $v0, 1		    	    # syscall 1: print int
	add	    $a0, $0, $s0
	syscall				            # print $s0 = array length
	jr	    $ra			            # jump to $ra

swap:								# 2 args: $a0 = i, $a1 = j
	mul		$t0, $a0, 4				# $t0 = i position in array
	add		$t1, $s1, $t0			# $t1 = array[i] address
	lw		$t2, 0($t1)				# $t2 = array[i] value
	mul		$t0, $a1, 4				# $t0 = j position in array
	add		$t3, $s1, $t0			# $t3 = array[j] address
	lw		$t4, 0($t3)				# $t4 = array[j] value
	sw		$t4, 0($t1)				# store $t4 = array[j] value into $t1 = array[i] address
	sw		$t2, 0($t3)				# store $t2 = arrai[i] value into $t3 = array[j] address
	jr		$ra						# jump to $ra

getLeftChildIndex:					# 1 arg: $a0 = index
	mul		$t8, $a0, 2				# $t8 = index * 2
	addi	$t8, $t8, 1				# $t8 = (index * 2) + 1
	jr		$ra						# jump to $ra

getRightChildIndex:					# 1 arg: $a0 = index
	mul		$t9, $a0, 2				# $t9 = index * 2
	addi	$t9, $t9, 2				# $t9 = (index * 2) + 2
	jr		$ra						# jump to $ra

fixHeap:							# 2 args: $a0 = rootIndex, $a1 = lastIndex
	addi	$sp, $sp, -4			# make space in stack
	sw		$ra, 0($sp)				# add $ra value to stack
	# remove root
	mul		$t0, $a0, 4				# $t0 = rootIndex position in array
	add		$t1, $s1, $t0			# $t1 = array[rootIndex] address
	lw		$s2, 0($t1)				# $s2 = array[rootIndex] value = rootValue
	# promote children while they are larger than the root
	add		$s3, $0, $a0			# $s3 = index
	addi	$s4, $0, 1				# $s4 = more = true = 1
while:
	bne		$s4, 1, done			# if $s4 != 1 then go to done
	add		$a0, $0, $s3			# arg 0 = $a0 = index
	jal		getLeftChildIndex		# jump to getLeftChildIndex and save position to $ra
	add		$t3, $0, $t8			# $t3 = childIndex
	bgt		$t3, $a1, else			# if $t3 > $a1 (childIndex > lastIndex), then go to else (no children)
	# use right child instead if it is larger
	jal		getRightChildIndex		# jump to getRightChildIndex and save position to $ra
	ble		$t9, $a1, if1			# if $t9 <= $a1 (rightChildIndex <= lastIndex), then go to if1
	j		if3						# else, jump to if3
if1:
	mul		$t9, $t9, 4				# $t9 = rightChildIndex position in array
	add		$s7, $t9, $s1			# $s7 = array[rightChildIndex] address
	lw		$s6, 0($s7)				# $s6 = array[rightChildIndex] value
	mul		$t3, $t3, 4				# $t3 = childIndex position in array
	add		$s7, $t3, $s1			# $s7 = array[childIndex] address
	lw		$s5, 0($s7)				# $s5 = array[childIndex] value
	bgt		$s6, $s5, if2			# if $s6 > $s5 (array[rightChildIndex] > array[childIndex]), then go to if2
	j		if3						# else, jump to if3
if2:
	div		$t9, $t9, 4				# $t9 = rightChildIndex
	add		$t3, $0, $t9			# $t3 = childIndex = rightChildIndex
if3:
	mul		$t3, $t3, 4				# $t3 = childIndex position in array
	add		$s7, $t3, $s1			# $s7 = array[childIndex] address
	lw		$s6, 0($s7)				# $s6 = array[childIndex] value
	bgt		$s6, $s2, then			# if $s6 > $s2 (array[childIndex] > rootValue), then go to then
	j		else					# else, jump to else (rootValue is larger than both children)
then:
	# promote child
	mul		$s3, $s3, 4				# $s3 = index position in array
	add		$s7, $s3, $s1			# $s7 = array[index] address
	sw		$s6, 0($s7)				# store $s6 = array[childIndex] value into $s7 = array[index] address
	div		$t3, $t3, 4				# $t3 = childIndex
	add		$s3, $0, $t3			# $s3 = index = childIndex
	j		while					# jump to while
else:
	# no children or root value is larger than both children
	addi	$s4, $0, -1				# more = 0 = false
	j		while					# jump to while
done:
	# store root value in vacant slot
	mul		$t0, $s3, 4				# $t0 = index position in array
	add		$t1, $s1, $t0			# $t1 = array[index] address
	sw		$s2, 0($t1)				# store $s2 = rootValue into $t1 = array[index] address
	lw		$ra, 0($sp)				# restore $ra
	addi	$sp, $sp, 4				# restore $sp
	jr		$ra						# jump to $ra

heapSort:							# 2 arguments: $a0 = array, $a1 = array length
	addi	$sp, $sp, -4			# make space in stack
	sw		$ra, 0($sp)				# add $ra value to stack
	addi	$s5, $s0, -1			# $s5 = n = array.length - 1
	addi	$s4, $s5, -1			# $s4 = n - 1
	div		$s4, $s4, 2				# $s4 = i = (n - 1)/2
forLoop:
	bltz 	$s4, whileLoop			# if $s4 < 0 (i is neg), then go to whileLoop
	add		$a0, $0, $s4			# arg 0 = $a0 = i
	add		$a1, $0, $s5			# arg 1 = $a1 = n
	jal		fixHeap					# jump to fixHeap and save position to $ra
	addi	$s4, $s4, -1			# $s4 = i - 1
	j		forLoop					# jump to forLoop
whileLoop:
	blez 	$s5, doneSort			# if $s5 <= 0 (n <= 0), then go to doneSort
	add		$a0, $0, $0				# arg 0 = $a0 = 0
	add		$a1, $0, $s5			# arg 1 = $a1 = n
	jal		swap					# jump to swab and save position to $ra
	addi	$s5, $s5, 1				# $s5 = n - 1
	add		$a0, $0, $0				# arg 0 = $a0 = 0
	add		$a1, $0, $s5			# arg 1 = $a1 = n
	jal		fixHeap					# jump to fixHeap and save position to $ra
	j		whileLoop				# jump to whileLoop
doneSort:
	lw		$ra, 0($sp)				# restore $ra
	addi	$sp, $sp, 4				# restore $sp
	jr		$ra						# jump to $ra