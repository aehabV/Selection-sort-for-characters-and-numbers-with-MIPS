		.data
size:		.asciiz "\nInsert the size of the array \n"
elements:	.asciiz "Insert the array elements,one per line  \n"
sorted:	.asciiz "After the array is sorted:   "
c:		.asciiz ", "
d:		.byte '.'
n:		.byte '\n'
		.text
		.globl	main
main: 
		li	$v0, 4			#Tell the system to print a string
		la	$a0, size		#Send the string to argument $a0
		syscall				#Call the system
		li	$v0, 5			#Tell the system to read an integer and store it in $v0
		syscall				#Call the system
		move	$s2, $v0		#Store the input value(size) of $v0 into $s2
		li	$v0, 4			#Tell the system to print a string
		la	$a0, elements 	#Send the string to argument $a0
		syscall				#Call the system
		move	$s1, $zero		#Initialize $s1 by zero
run_loop:	
		bge	$s1, $s2, exit_loop	#Check if $s1(counter) >= $s2(size) then go to exit_loop
		sll	$t0, $s1, 2		#Shift left $s1(counter)  by 2 and store the value in $t0(index of ith element); $s1*4(bytes of integer)
		add	$t1, $t0, $sp	#Add $t0(index of ith element) to $sp(stack pointer) and store the value in $t1(address of ith element)
		li	$v0, 5			#Tell the system to read an integer and store it in $v0
		syscall				#Call the system
		sw	$v0, ($t1)		#Save the input value of $v0 in index i
		li	$v0, 4			#Tell the system to print a string
		la	$a0, n			#Send the string to argument $a0
		syscall				#Call the system
		addi	$s1, $s1, 1		#Increment the counter by 1
		j	run_loop		#Jump to run_loop again
		
exit_loop:	
		move	$a0, $sp		#Copy the address of $sp(stack pointer) into argument $a0
		move	$a1, $s2		#Copy the value of $s2(size) into argument $a1
		jal	Selection_Sort	#Call the sort function
		li	$v0, 4			#Tell the system to print a string
		la	$a0, sorted		#Send the string to argument $a0
		syscall				#Call the system

print:		
		move	$s1, $zero		#Initialize $s1 by zero
ploop:		
		bge	$s1, $s2, exit_print	#Check if $s1(counter) >= $s2(size) then go to exit_print
		sll	$t0, $s1, 2		#Shift left $s1(counter)  by 2 and store the value in $t0(index of ith element); $s1*4(bytes of integer)
		add	$t1, $t0, $sp	#Add $t0(index of ith element) to $sp(stack pointer) and store the value in $t1(address of ith element)
		lw	$a0, ($t1)		#Store the returned value in argument $a0
		li	$v0, 1			#Tell the system to print an integer
		syscall				#Call the system
		addi	$s1, $s1, 1		#Increment the counter by 1
		bge 	$s1, $s2, exit_temp	#Check if $s1(counter) >= $s2(size) then go to exit_temp	
		li	$v0, 4			#Tell the system to print a string
		la	$a0, c			#Send the string to argument $a0
		syscall				#Call the system
exit_temp:
		j	ploop			#Jump to ploop again
		
exit_print:	
		li	$v0, 4			#Tell the system to print a string
		la	$a0, d			#Send the string to argument $a0
		syscall				#Call the system
		li	$v0, 10		#Exit the program
		syscall				#Call the system

Selection_Sort:		
		addi	$sp, $sp, -16	#Push 5 elements in the stack
		sw	$s0, 0($sp)		#Save value of $s0 in index 0
		sw	$s1, 4($sp)		#Save value of $s1 in index 1
		sw	$s2, 8($sp)		#Save value of $s2 in index 2
		sw	$ra, 12($sp)		#Save the return address in index 3
		move 	$s0, $a0		#Copy the base address of the array to $s0
		move	$s1, $zero		#Initialize $s1 by zero
		subi	$s2, $a1, 1		#Subtract 1 from $a1 and store the value in $s2
		
Sort_loop:	
		bge 	$s1, $s2, Selection_Sort_exit	#Check if $s1(counter) >= $s2(size-1) then go to Selection_Sort_exit
		move	$a0, $s0		#Copy the base address of the array to $a0
		move	$a1, $s1		#Copy the value of $s1(counter) into argument $a1
		move	$a2, $s2		#Copy the value of $s2(size-1) into argument $a2
		jal	min			#Call min function
		move	$a2, $v0		#Store the returned value(index of min) of $v0 into  argument $a2
		jal	swap			#Call the swap function
		addi	$s1, $s1, 1		#Increment the counter by 1
		j	Sort_loop		#Jump to Sort_loop again
				
Selection_Sort_exit:	
		lw	$s0, 0($sp)		#Load value at index 0 into $s0
		lw	$s1, 4($sp)		#Load value at index 1 into $s1
		lw	$s2, 8($sp)		#Load value at index 2 into $s2
		lw	$ra, 12($sp)		#Load the return address at index 3 into $ra
		addi	$sp, $sp, 16		#Pop 4 elements from the stack (i.e. adjust the stack pointer) 
		jr	$ra			#Return address (i.e. exit the funcion)

min:		
		move	$t0, $a0		#Copy the base address of the array to $t0
		move	$t1, $a1		#Copy the value of argument $a1(counter) into $t1
		move	$t2, $a2		#Copy the value of argument $a2(size-1) into $t2
		move	$t5, $t1		#Copy the value of $t1(counter) into $t5
		sll	$t3, $t1, 2		#Shift left $t1(counter)  by 2 and store the value in $t3(index of ith element); $t1*4(bytes of integer)
		add	$t3, $t3, $t0	#Add $t3(index of ith element) to $t0(base address) and store the value in $t3(address of ith element)		
		lw	$t4, ($t3)		#Store the returned value in $t4(current element/min)
		
min_loop:	
		bgt	$t5, $t2, min_exit	#Check if $t5(counter) >= $t2(size-1) then go to min_exit
		sll	$t6, $t5, 2		#Shift left $t5(counter)  by 2 and store the value in $t6(index of ith element); $t5*4(bytes of integer)
		add	$t6, $t6, $t0	#Add $t6(index of ith element) to $t0(base address) and store the value in $t6(address of ith element)		
		lw	$t7, ($t6)		#Store the returned value in $t7(ith element)
		bge	$t7, $t4, chk_exit	#Check if $t7(ith element) >= $t2(current element/min) then go to min_exit
		move	$t1, $t5		#Copy the value(address of new min) of  $t5 into $t1
		move	$t4, $t7		#Copy the value of $t7(new min) into $t4(old min)

chk_exit:	
		addi	$t5, $t5, 1		#Increment the counter by 1
		j	min_loop		#Jump to min_loop again

min_exit:	
		move 	$v0, $t1		#Return the index of the min character in $v0
		jr	$ra			#Return address (i.e. exit the funcion)
		
swap:		
		sll	$t1, $a1, 2		#Shift left $a1(counter)  by 2 and store the value in $t1; $a1*4(bytes of integer)
		add	$t1, $t1, $a0		#Add $t1(index of ith element) to $a0(base address) and store the value in $t1(address of ith element)		
		sll	$t2, $a2, 2		#Shift left $a2(index of min)  by 2 and store the value in $t2; $a2*4(bytes of integer)
		add	$t2, $t2, $a0	#Add $t1(index of min) to $a0(base address) and store the value in $t2(address of of min)
		lw	$t0, ($t1)		#Load the integer of index $t1(counter) in $t0; $t0 = a[counter]
		lw	$t3, ($t2)		#Load character of index $t2(minimum) in $t3; $t3 = a[min]
		sw	$t3, ($t1)		#Store integer(minimum) of $t3 at index $t1(counter); s[counter] = s[min]
		sw	$t0, ($t2)		#Store integer(counter) of $t0 at index $t2(minimum); s[min] = s[counter]
		jr	$ra			#Return address	(i.e. exit the funcion)