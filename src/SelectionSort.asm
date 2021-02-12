		.data
choice:		.asciiz "\nPlease select your choice: \n 1-Sort Integers\t2-Sort Characters\n"
size:		.asciiz "\nInsert the size of the array \n"
buffer:	.byte 100			#Reserve 100 byte in the meomery for 100 charachters
elementsI:	.asciiz "Insert the array elements,one per line  \n"
elementsC:	.asciiz "\nInsert the array elements: "
sorted:	.asciiz "After the array is sorted:   "
c:		.asciiz ", "
d:		.byte '.'
n:		.byte '\n'
		.text
		.globl	main
		
main:		
		li	$v0, 4			#Tell the system to print a string
		la	$a0, choice		#Send the string to argument $a0
		syscall				#Call the system
		li	$v0, 5			#Tell the system to read an integer and store it in $v0
		syscall				#Call the system
		move	$s1, $v0		#Store the input value(size) of $v0 into $s2
		move	$s2, $zero		#Initialize $s2 by zero
		move	$s3, $zero		#Initialize $s3 by zero
		addi	$s2, $s2, 1		#Increment $s2 by 1
		addi	$s3, $s2, 1		#Increment $s2 by 1 and store the value into $s3
		beq	$s1, $s2, Selection_Sort_Int	#Check if $s1(choice) = $s2 then go to Selection_Sort_Int
		beq	$s1, $s3, Selection_Sort_Char	#Check if $s1(choice) = $s3 then go to Selection_Sort_Char
		
Selection_Sort_Int: 
		li	$v0, 4			#Tell the system to print a string
		la	$a0, size		#Send the string to argument $a0
		syscall				#Call the system
		li	$v0, 5			#Tell the system to read an integer and store it in $v0
		syscall				#Call the system
		move	$s2, $v0		#Store the input value(size) of $v0 into $s2
		li	$v0, 4			#Tell the system to print a string
		la	$a0, elementsI 	#Send the string to argument $a0
		syscall				#Call the system
		move	$s1, $zero		#Initialize $s1 by zero
run_loopI:	
		bge	$s1, $s2, exit_loopI	#Check if $s1(counter) >= $s2(size) then go to exit_loop
		sll	$t0, $s1, 2		#Shift left $s1(counter)  by 2 and store the value in $t0(index of ith element); $s1*4(bytes of integer)
		add	$t1, $t0, $sp	#Add $t0(index of ith element) to $sp(stack pointer) and store the value in $t1(address of ith element)
		li	$v0, 5			#Tell the system to read an integer and store it in $v0
		syscall				#Call the system
		sw	$v0, ($t1)		#Save the input value of $v0 in index i
		li	$v0, 4			#Tell the system to print a string
		la	$a0, n			#Send the string to argument $a0
		syscall				#Call the system
		addi	$s1, $s1, 1		#Increment the counter by 1
		j	run_loopI		#Jump to run_loop again
		
exit_loopI:	
		move	$a0, $sp		#Copy the address of $sp(stack pointer) into argument $a0
		move	$a1, $s2		#Copy the value of $s2(size) into argument $a1
		jal	Selection_SortI	#Call the sort function
		li	$v0, 4			#Tell the system to print a string
		la	$a0, sorted		#Send the string to argument $a0
		syscall				#Call the system

printI:		
		move	$s1, $zero		#Initialize $s1 by zero
ploopI:		
		bge	$s1, $s2, exit_printI#Check if $s1(counter) >= $s2(size) then go to exit_print
		sll	$t0, $s1, 2		#Shift left $s1(counter)  by 2 and store the value in $t0(index of ith element); $s1*4(bytes of integer)
		add	$t1, $t0, $sp	#Add $t0(index of ith element) to $sp(stack pointer) and store the value in $t1(address of ith element)
		lw	$a0, ($t1)		#Store the returned value in argument $a0
		li	$v0, 1			#Tell the system to print an integer
		syscall				#Call the system
		addi	$s1, $s1, 1		#Increment the counter by 1
		bge 	$s1, $s2, exit_tempI	#Check if $s1(counter) >= $s2(size) then go to exit_temp	
		li	$v0, 4			#Tell the system to print a string
		la	$a0, c			#Send the string to argument $a0
		syscall				#Call the system
exit_tempI:
		j	ploopI			#Jump to ploop again
		
exit_printI:	
		li	$v0, 4			#Tell the system to print a string
		la	$a0, d			#Send the string to argument $a0
		syscall				#Call the system
		li	$v0, 10		#Exit the program
		syscall				#Call the system

Selection_SortI:		
		addi	$sp, $sp, -16	#Push 5 elements in the stack
		sw	$s0, 0($sp)		#Save value of $s0 in index 0
		sw	$s1, 4($sp)		#Save value of $s1 in index 1
		sw	$s2, 8($sp)		#Save value of $s2 in index 2
		sw	$ra, 12($sp)		#Save the return address in index 3
		move 	$s0, $a0		#Copy the base address of the array to $s0
		move	$s1, $zero		#Initialize $s1 by zero
		subi	$s2, $a1, 1		#Subtract 1 from $a1 and store the value in $s2
		
Sort_loopI:	
		bge 	$s1, $s2, Selection_Sort_exitI	#Check if $s1(counter) >= $s2(size-1) then go to Selection_Sort_exit
		move	$a0, $s0		#Copy the base address of the array to $a0
		move	$a1, $s1		#Copy the value of $s1(counter) into argument $a1
		move	$a2, $s2		#Copy the value of $s2(size-1) into argument $a2
		jal	minI			#Call min function
		move	$a2, $v0		#Store the returned value(index of min) of $v0 into  argument $a2
		jal	swapI			#Call the swap function
		addi	$s1, $s1, 1		#Increment the counter by 1
		j	Sort_loopI		#Jump to Sort_loop again
				
Selection_Sort_exitI:	
		lw	$s0, 0($sp)		#Load value at index 0 into $s0
		lw	$s1, 4($sp)		#Load value at index 1 into $s1
		lw	$s2, 8($sp)		#Load value at index 2 into $s2
		lw	$ra, 12($sp)		#Load the return address at index 3 into $ra
		addi	$sp, $sp, 16		#Pop 4 elements from the stack (i.e. adjust the stack pointer) 
		jr	$ra			#Return address (i.e. exit the funcion)

minI:		
		move	$t0, $a0		#Copy the base address of the array to $t0
		move	$t1, $a1		#Copy the value of argument $a1(counter) into $t1
		move	$t2, $a2		#Copy the value of argument $a2(size-1) into $t2
		move	$t5, $t1		#Copy the value of $t1(counter) into $t5
		sll	$t3, $t1, 2		#Shift left $t1(counter)  by 2 and store the value in $t3(index of ith element); $t1*4(bytes of integer)
		add	$t3, $t3, $t0	#Add $t3(index of ith element) to $t0(base address) and store the value in $t3(address of ith element)		
		lw	$t4, ($t3)		#Store the returned value in $t4(current element/min)
		
min_loopI:	
		bgt	$t5, $t2, min_exitI	#Check if $t5(counter) >= $t2(size-1) then go to min_exit
		sll	$t6, $t5, 2		#Shift left $t5(counter)  by 2 and store the value in $t6(index of ith element); $t5*4(bytes of integer)
		add	$t6, $t6, $t0	#Add $t6(index of ith element) to $t0(base address) and store the value in $t6(address of ith element)		
		lw	$t7, ($t6)		#Store the returned value in $t7(ith element)
		bge	$t7, $t4, chk_exitI	#Check if $t7(ith element) >= $t2(current element/min) then go to min_exit
		move	$t1, $t5		#Copy the value(address of new min) of  $t5 into $t1
		move	$t4, $t7		#Copy the value of $t7(new min) into $t4(old min)

chk_exitI:	
		addi	$t5, $t5, 1		#Increment the counter by 1
		j	min_loopI		#Jump to min_loop again

min_exitI:	
		move 	$v0, $t1		#Return the index of the min character in $v0
		jr	$ra			#Return address (i.e. exit the funcion)
		
swapI:		
		sll	$t1, $a1, 2		#Shift left $a1(counter)  by 2 and store the value in $t1; $a1*4(bytes of integer)
		add	$t1, $t1, $a0		#Add $t1(index of ith element) to $a0(base address) and store the value in $t1(address of ith element)		
		sll	$t2, $a2, 2		#Shift left $a2(index of min)  by 2 and store the value in $t2; $a2*4(bytes of integer)
		add	$t2, $t2, $a0	#Add $t1(index of min) to $a0(base address) and store the value in $t2(address of of min)
		lw	$t0, ($t1)		#Load the integer of index $t1(counter) in $t0; $t0 = a[counter]
		lw	$t3, ($t2)		#Load character of index $t2(minimum) in $t3; $t3 = a[min]
		sw	$t3, ($t1)		#Store integer(minimum) of $t3 at index $t1(counter); s[counter] = s[min]
		sw	$t0, ($t2)		#Store integer(counter) of $t0 at index $t2(minimum); s[min] = s[counter]
		jr	$ra			#Return address	(i.e. exit the funcion)

Selection_Sort_Char: 	
		li	$v0, 4			#Tell the system to print a string
		la	$a0, elementsC 	#Send the string to argument $a0 		
		syscall				#Call the system
		li	$v0, 8			#Tell the system to read a string
		la	$a0, buffer		# Read the string
		li	$a1, 100		#Allocate  space in the meomery for the string
		syscall				#Call the system
		la	$t0, buffer		#Load address of the buffer to $t0		
run_loopC:
		lb	$t1, ($t0)		#Load from $t0 the ith character of the string in $t1; $t1 = s[i]
		beq	$t1, '\0', exit_loopC #Check if it is the end of string or not
		addi	$t0, $t0, 1		#Increment the index of the current position by 1 (i++)
		addi	$s0, $s0, 1		#Increment the counter (count number of characters in the string) by 1
		j	run_loopC		#Jump to run_loop again 
exit_loopC:	
		subi	$s0, $s0, 1		#Decrease the value of $s0 by 1
		move	$a0, $s0		#Copy the value of $s0(num of characters in string) into argument $a0
		la	$a1, buffer		#Load address of the buffer(unsorted string) to argument $a1
		jal	Selection_SortC	#Call the sort function
		li	$v0, 4			#Tell the system to print a string
		la	$a0, sorted		#Send the string to argument $a0
		syscall				#Call the system
		la	$a1, buffer		#Load address of the buffer(sorted string) to argument $a1
		move	$a2, $s0		#Copy the value of $s0(counter) into argument $a2
		jal	printC			#Call print function
		li	$v0, 10		#Exit the program
		syscall				#Call the system
printC:		
		addi	$sp, $sp, -8		#Push 2 elements in the stack
		sw	$s1, 0($sp)		#Save value of $s1 in index 0
		sw	$s2, 4($sp)		#Save value of $s2 in index 1
		move	$s1, $zero		#Initialize $s1 by zero
		move	$s2, $a2		#Copy the value of argument $a2(counter) into $s2
ploopC:		
		bge	$s1, $s2, exit_printC#Check if $s1(counter) >= $s2(num of characters in string) then go to exit_print
		lb	$t1, ($a1)		#Load ith character of the string in $t1; $t1 = s[i]
		li	$v0, 11		#Tell the system to print a character	
		la	$a0, ($t1)		#Load the address of $t1 into argument $a0
		syscall				#Call the system
		addi	$a1, $a1, 1		#Increment the index of the current position by 1 (i++)
		addi	$s1, $s1, 1		#Increment the counter by 1
		bge 	$s1, $s2, exit_tempC	#Check if $s1(counter) >= $s2(num of characters in string) then go to exit_temp
		li	$v0, 4			#Tell the system to print a string	
		la	$a0, c			#Send the string to argument $a0
		syscall				#Call the system
		j	ploopC			#Jump to ploop again
exit_tempC:
		j	ploopC			#Jump to ploop again
exit_printC:
		lw	$s1, 0($sp)		#Load value at index 0 into $s1
		lw	$s2, 4($sp)		#Load value at index 1 into $s2
		addi	$sp, $sp, 8		#Pop 2 elements from the stack (i.e. adjust the stack pointer)
		li	$v0, 4			#Tell the system to print a string
		la	$a0, d			#Send the string to argument $a0
		syscall				#Call the system
		jr	$ra	 		#Return address (i.e. exit the funcion)
		
Selection_SortC:
		addi	$sp, $sp, -16	#Push 4 elements in the stack
		sw	$s1, 0($sp)		#Save value of $s1 in index 0
		sw	$s2, 4($sp)		#Save value of $s2 in index 1
		sw	$s3, 8($sp)		#Save value of $s3 in index 2
		sw	$ra, 12($sp)		#Save the return address in index 3
		move	$s3, $zero		#Initialize $s3 by zero
		move	$s2, $a0		#Copy the value of argument $a0(num of characters in string) into $s2
Sort_loopC:	
		bge 	$s3, $s2, Selection_Sort_exitC	#Check if $s3(counter) >= $s2(num of characters in string) then go to Selection_Sort_exit
		la	$a1, buffer		#Load address of the buffer(unsorted string) to argument $a1
		move	$a0, $s3		#Copy the value of $s3(counter) into  argument $a0
		add	$a1, $a1, $s3		#Add $s3(counter) to argument $a1 and store the value in $a1 
		move	$a2, $a1		#Copy the value(address) of argument $a1 into  argument $a2
		move	$a3, $s2		#Copy the value of $s2(num of characters in string) into  argument $a3
		jal	minC			#Call min function
		move	$a2, $v0		#Store the returned value(index of min) of $v0 into  argument $a2
		jal	swapC			#Call the swap function
		addi	$s3, $s3, 1		#Increment the counter by 1
		j	Sort_loopC		#Jump to Sort_loop again
Selection_Sort_exitC:
		lw	$s1, 0($sp)		#Load value at index 0 into $s1
		lw	$s2, 4($sp)		#Load value at index 1 into $s2
		lw	$s3, 8($sp)		#Load value at index 2 into $s3
		lw	$ra, 12($sp)		#Load the return address at index 3 into $ra
		addi	$sp, $sp, 16		#Pop 4 elements from the stack (i.e. adjust the stack pointer)
		jr	$ra			#Return address (i.e. exit the funcion)
minC:		
		move	$s1, $a0		#Copy the value of argument $a0(counter) into $s1
		move	$t1, $a2		#Copy the value(address) of argument $a2 into $t1
		move	$t3, $a3		#Copy the value of argument $a3(num of characters in string) into $t3
		move	$t4, $t1		#Copy the value(address) of $t1 into $t4
		lb	$t5, ($t1)		#Load from $t1 the ith character of the string in $t5(current character/min); $t5(min) = s[i]
min_loopC:	
		bge	$s1, $t3, min_exitC	#Check if $s1(counter) >= $t3(num of characters in string) then go to min_exit
		lb	$t6, ($t4)		#Load from $t4 the ith character of the string in $t6; $t6 = s[i]
		bge	$t6, $t5, chk_exitC	#Check if $t6(ith character) >= $t5(current character/min) then go to chk_exit
		move	$t1, $t4		#Copy the value(address of new min) of  $t4 into $t1
		move	$t5, $t6		#Copy the value of $t6(new min) into $t5(old min)
		addi	$s1, $s1, 1		#Increment the counter by 1
		addi	$t4, $t4, 1		#Increment the index of the current position by 1 (i++)
		j	min_loopC		#Jump to min_loop again
chk_exitC:	
		addi	$s1, $s1, 1		#Increment the counter by 1
		addi	$t4, $t4, 1		#Increment the index of the current position by 1 (i++)
		j	min_loopC		#Jump to min_loop again
min_exitC:	
		move 	$v0, $t1		#Return the index of the min character in $v0
		jr	$ra			#Return address (i.e. exit the funcion)
swapC:		
		lb	$t0, ($a1)		#Load the character of index $a1(counter) from the string in $t0; $t0 = s[counter]
		lb	$t3, ($a2)		#Load character of index $a2(minimum) from the string in $t3; $t3 = s[min]
		sb	$t3, ($a1)		#Store character(minimum) of $t3 at index $a1(counter); s[counter] = s[min]
		sb	$t0, ($a2)		#Store character(counter) of $t0 at index $a2(minimum); s[min] = s[counter]
		jr	$ra			#Return address	(i.e. exit the funcion)
