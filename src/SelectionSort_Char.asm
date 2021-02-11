		.data
buffer:	.byte 100			#Reserve 100 byte in the meomery for 100 charachters
elements:	.asciiz "\nInsert the array elements:  "
sorted:	.asciiz "\nAfter the array is sorted:   "
c:		.asciiz ", "
d:		.byte '.'
		.text
		.globl main
		
main: 	
		li	$v0, 4			#Tell the system to print a string
		la	$a0, elements 	#Send the string to argument $a0 		
		syscall				#Call the system
		li	$v0, 8			#Tell the system to read a string
		la	$a0, buffer		# Read the string
		li	$a1, 100		#Allocate  space in the meomery for the string
		syscall				#Call the system
		la	$t0, buffer		#Load address of the buffer to $t0		
run_loop:
		lb	$t1, ($t0)		#Load from $t0 the ith character of the string in $t1; $t1 = s[i]
		beq	$t1, '\0', exit_loop #Check if it is the end of string or not
		addi	$t0, $t0, 1		#Increment the index of the current position by 1 (i++)
		addi	$s0, $s0, 1		#Increment the counter (count number of characters in the string) by 1
		j	run_loop		#Jump to run_loop again 
exit_loop:	
		subi	$s0, $s0, 1		#Decrease the value of $s0 by 1
		move	$a0, $s0		#Copy the value of $s0(num of characters in string) into argument $a0
		la	$a1, buffer		#Load address of the buffer(unsorted string) to argument $a1
		jal	Selection_Sort	#Call the sort function
		li	$v0, 4			#Tell the system to print a string
		la	$a0, sorted		#Send the string to argument $a0
		syscall				#Call the system
		la	$a1, buffer		#Load address of the buffer(sorted string) to argument $a1
		move	$a2, $s0		#Copy the value of $s0(counter) into argument $a2
		jal	print			#Call print function
		li	$v0, 10		#Exit the program
		syscall				#Call the system
print:		
		addi	$sp, $sp, -8		#Push 2 elements in the stack
		sw	$s1, 0($sp)		#Save value of $s1 in index 0
		sw	$s2, 4($sp)		#Save value of $s2 in index 1
		move	$s1, $zero		#Initialize $s1 by zero
		move	$s2, $a2		#Copy the value of argument $a2(counter) into $s2
ploop:		
		bge	$s1, $s2, exit_print#Check if $s1(counter) >= $s2(num of characters in string) then go to exit_print
		lb	$t1, ($a1)		#Load ith character of the string in $t1; $t1 = s[i]
		li	$v0, 11		#Tell the system to print a character	
		la	$a0, ($t1)		#Load the address of $t1 into argument $a0
		syscall				#Call the system
		addi	$a1, $a1, 1		#Increment the index of the current position by 1 (i++)
		addi	$s1, $s1, 1		#Increment the counter by 1
		bge 	$s1, $s2, exit_temp	#Check if $s1(counter) >= $s2(num of characters in string) then go to exit_temp
		li	$v0, 4			#Tell the system to print a string	
		la	$a0, c			#Send the string to argument $a0
		syscall				#Call the system
		j	ploop			#Jump to ploop again
exit_temp:
		j	ploop			#Jump to ploop again
exit_print:
		lw	$s1, 0($sp)		#Load value at index 0 into $s1
		lw	$s2, 4($sp)		#Load value at index 1 into $s2
		addi	$sp, $sp, 8		#Pop 2 elements from the stack (i.e. adjust the stack pointer)
		li	$v0, 4			#Tell the system to print a string
		la	$a0, d			#Send the string to argument $a0
		syscall				#Call the system
		jr	$ra	 		#Return address (i.e. exit the funcion)
		
Selection_Sort:
		addi	$sp, $sp, -16	#Push 4 elements in the stack
		sw	$s1, 0($sp)		#Save value of $s1 in index 0
		sw	$s2, 4($sp)		#Save value of $s2 in index 1
		sw	$s3, 8($sp)		#Save value of $s3 in index 2
		sw	$ra, 12($sp)		#Save the return address in index 3
		move	$s3, $zero		#Initialize $s3 by zero
		move	$s2, $a0		#Copy the value of argument $a0(num of characters in string) into $s2
Sort_loop:	
		bge 	$s3, $s2, Selection_Sort_exit	#Check if $s3(counter) >= $s2(num of characters in string) then go to Selection_Sort_exit
		la	$a1, buffer		#Load address of the buffer(unsorted string) to argument $a1
		move	$a0, $s3		#Copy the value of $s3(counter) into  argument $a0
		add	$a1, $a1, $s3		#Add $s3(counter) to argument $a1 and store the value in $a1 
		move	$a2, $a1		#Copy the value(address) of argument $a1 into  argument $a2
		move	$a3, $s2		#Copy the value of $s2(num of characters in string) into  argument $a3
		jal	min			#Call min function
		move	$a2, $v0		#Store the returned value(index of min) of $v0 into  argument $a2
		jal	swap			#Call the swap function
		addi	$s3, $s3, 1		#Increment the counter by 1
		j	Sort_loop		#Jump to Sort_loop again
Selection_Sort_exit:
		lw	$s1, 0($sp)		#Load value at index 0 into $s1
		lw	$s2, 4($sp)		#Load value at index 1 into $s2
		lw	$s3, 8($sp)		#Load value at index 2 into $s3
		lw	$ra, 12($sp)		#Load the return address at index 3 into $ra
		addi	$sp, $sp, 16		#Pop 4 elements from the stack (i.e. adjust the stack pointer)
		jr	$ra			#Return address (i.e. exit the funcion)
min:		
		move	$s1, $a0		#Copy the value of argument $a0(counter) into $s1
		move	$t1, $a2		#Copy the value(address) of argument $a2 into $t1
		move	$t3, $a3		#Copy the value of argument $a3(num of characters in string) into $t3
		move	$t4, $t1		#Copy the value(address) of $t1 into $t4
		lb	$t5, ($t1)		#Load from $t1 the ith character of the string in $t5(current character/min); $t5(min) = s[i]
min_loop:	
		bge	$s1, $t3, min_exit	#Check if $s1(counter) >= $t3(num of characters in string) then go to min_exit
		lb	$t6, ($t4)		#Load from $t4 the ith character of the string in $t6; $t6 = s[i]
		bge	$t6, $t5, chk_exit	#Check if $t6(ith character) >= $t5(current character/min) then go to chk_exit
		move	$t1, $t4		#Copy the value(address of new min) of  $t4 into $t1
		move	$t5, $t6		#Copy the value of $t6(new min) into $t5(old min)
		addi	$s1, $s1, 1		#Increment the counter by 1
		addi	$t4, $t4, 1		#Increment the index of the current position by 1 (i++)
		j	min_loop		#Jump to min_loop again
chk_exit:	
		addi	$s1, $s1, 1		#Increment the counter by 1
		addi	$t4, $t4, 1		#Increment the index of the current position by 1 (i++)
		j	min_loop		#Jump to min_loop again
min_exit:	
		move 	$v0, $t1		#Return the index of the min character in $v0
		jr	$ra			#Return address (i.e. exit the funcion)
swap:		
		lb	$t0, ($a1)		#Load the character of index $a1(counter) from the string in $t0; $t0 = s[counter]
		lb	$t3, ($a2)		#Load character of index $a2(minimum) from the string in $t3; $t3 = s[min]
		sb	$t3, ($a1)		#Store character(minimum) of $t3 at index $a1(counter); s[counter] = s[min]
		sb	$t0, ($a2)		#Store character(counter) of $t0 at index $a2(minimum); s[min] = s[counter]
		jr	$ra			#Return address	(i.e. exit the funcion)