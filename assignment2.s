####################################
#Seth Wideman
#Assignment2
####################################
	.data
Prompt1: .asciiz "\n Please enter the first string: "
Prompt2: .asciiz "\n Please enter the second string: "
length1: .asciiz "\n String 1 has a length of "
length2: .asciiz "\n String 2 has a length of "
equal: .asciiz "\n The two strings are equal. "
notequal: .asciiz "\n The two string are not equal. "
appended: .asciiz "\n The appended string is "
bye: .asciiz "\n Have a nice day."

	.text
	.globl main

main:
	li $v0, 4 #printstr
	la $a0, Prompt1 #print Prompt1
	syscall
	
	li $v0, 9 #allocate memory
	li $a0, 80 #80 bits in $a0
	syscall
	
	move $t0, $v0 #string pointer string 1
	move $s0, $v0 #string memory start string 1
	
	li $v0, 8 #read string
	move $a0, $t0 #move $t0 to $a0
	syscall
	
	jal getLength
	move $t4, $t8 #move length of string 1 to $t4
	
	li $v0, 4 #printstr
	la $a0, Prompt2 #print Prompt2
	syscall
	
	li $v0, 9 #allocate memory
	li $a0, 80 #80 bits in $a0
	syscall
	
	move $t0, $v0 #string pointer string 2
	move $s1, $v0 #string memory start string 2
	
	li $v0, 8 #read string
	move $a0, $t0 #move $t0 to $a0
	syscall
	
	jal getLength
	move $t5, $t8 #move length of string 2 into t5
	
	jal printLength #jump to printLength function
	add $s2, $t4, $t5 #storing the sum of lengths of strings in $s2
	addi $s2, 1 #adding one to total length for blank space
	
	bne $t4, $t5, notEqual #branch if they have different lengths
	jal equality
	jal appendString
	
	b endGame #branch to end of program
	

getLength:
	li $t8, -1 #length counter starts at -1
	loop:
		lb $t7, 0($t0) #load string char into t7
		beq $t7, $0, doneLength #branch out of loop if blank character
		addi $t0, $t0, 1 #increment pointer by 1
		addi $t8, $t8, 1 #increment counter by 1
		b loop #loop again
	doneLength:
		jr $ra #back to main after function
		

printLength:
	li $v0, 4 #printstr
	la $a0, length1 #load length1 string
	syscall
	li $v0, 1 #print int
	move $a0, $t4 #move string 1 length into $a0
	syscall
	
	li $v0, 4 #printstr
	la $a0, length2 #load length2 string
	syscall
	li $v0, 1 #print int
	move $a0, $t5 #move string 2 length into $a0
	syscall
	jr $ra #return to main after call

		
notEqual:
	li $v0, 4 #printstr
	la $a0, notequal #load notequal prompt
	syscall
	jal appendString #call append function
	b endGame #branch to end
	
	
equality:
	move $t0, $s0 #move string 1 pointer into $t0
	move $t1, $s1 #move string 2 pointer into $t1
	li $t8, 0 #counter starts at 0
	equalLoop:
		lb $t2, 0($t0) #load character from string 1 into $t2
		lb $t3, 0($t1) #load character from string 2 into $t3
		bne $t2, $t3, notSame #branch if the characters arent the same
		beq $t8, $t4, doneEquality #branch if counter = length of string
		addi $t0, $t0, 1 #increment string 1 pointer
		addi $t1, $t1, 1 #increment string 2 pointer
		addi $t8, $t8, 1 #increment counter
		b equalLoop #branch to equalLoop
	doneEquality:
		li $v0, 4 #printstr
		la $a0, equal #load equal string
		syscall
		jr $ra
	notSame:
		li $v0, 4 #printstr
		la $a0, notequal #load equal string
		syscall
		jr $ra
		
		
appendString:
	move $t0, $s0 #move string 1 pointer into $t0
	move $t1, $s1 #move string 2 pointer into $t1
	li $v0, 9 #allocate memory
	li $s8, 0
	add $a0, $s8, $s2 # dynamically allocates enough memory to store string 1 and 2 and a space
	syscall
	move $s3, $v0 #move address of memory to s3
	move $t9, $v0 #move pointer to $t9
	li $t8, 0 #counter starts at 0
	appendLoop1:
		lb $t2 0($t0) #load character into $t2 from string
		sb $t2, 0($t9) #store character from string 1 into $t9
		beq $t8, $t4, appendSecond #branch if counter equals length of string 1
		addi $t0, 1 #increment pointer
		addi $t8, 1 #increment counter
		addi $t9, 1 #increment string pointer
		b appendLoop1
	appendSecond:
		li $t6, 32
		sb $t6, 0($t9)
		addi $t9, 1 #increment append string by 1
		li $t8, 1 #start counter at 0
		appendLoop2:
			lb $t3, 0($t1) #load character from string 2 into $t2
			sb $t3, 0($t9) #store byte in $t2 into address $t9
			beq $t8, $t5, doneAppend
			addi $t1, 1 #increment pointer
			addi $t8, 1 #increment counter
			addi $t9, 1 #increment string pointer
			b appendLoop2
	doneAppend:
		li $v0, 4 #printstr
		la $a0, appended #load appended string
		syscall
		li $v0, 4 #print string
		move $a0, $s3
		syscall
		jr $ra #return to main after call
		
	
endGame:
	li $v0, 4
	la $a0, bye
	syscall
	li $v0, 10
	syscall
	