####################################
#Seth Wideman
#Lab5
####################################
	.data
Prompt: .asciiz "\n Please enter an encoded data string: "
Echo: .asciiz "\n The Base 64 encoded input data was: "
Output: .asciiz "\n The decoded ASCII output is: "
Bye: .asciiz "\n Have a nice day!"
Newline: .asciiz "\n"

	.text
	.globl main
	
main:
	li $v0, 4 #printstr
	la $a0, Prompt #print Prompt
	syscall
	
	########################################
	# allocating memory for the input string
	########################################
	li $v0, 9 #allocate memory
	li $a0, 80 #80 bits in $a0
	syscall
	
	move $t0, $v0 #string pointer
	move $s0, $v0 #string memory start
	
	li $v0, 8 #read string
	move $a0, $t0 #move memory location to $a0
	syscall
	
	li $t9, 10 #load newline value into $t9
	lb $t8, 0($t0) #load 1st byte from input string into $t2
	beq $t8, $t9, end #branch to end if first char is newline
	
	jal printEncoded
	
	#######################################
	#allocating memory for alphabet storage
	#######################################
	li $v0, 9 #allocate memory
	li $a0, 80 #80 bits in $a0
	syscall
	
	move $t1, $v0 #string pointer
	move $s1, $v0 #string memory start
	
	#########################################
	#storing 64 bit alphabet into main memory
	#########################################
	li $t9, 65 #alphabet pointer starting at A
	li $t8, 91 #set $t8 to stopping point for Capital setter
	jal setCapitals
	li $t9, 97 #aphabet pointer starting at a
	li $t8, 123 #set $t8 to stopping point for Capital setter
	jal setLowers
	li $t9, 48 #alphabet pointer starting at 0
	li $t8, 58 #set $t8 to stopping point for Capital setter
	jal setNumbers
	li $t9, 43 #alphabet pointer for +, increment by 4 for /
	jal setOthers
	
	
	li $v0, 9 #allocate memory
	li $a0, 80 #80 bits in $a0
	syscall
	
	move $s7, $v0 #string pointer
	move $s8, $v0 #string memory start
	
	jal bigLoop
	
	
	b main
	
printEncoded:
	li $v0, 4 #printstr
	la $a0, Echo
	syscall
	move $a0, $s0
	syscall
	jr $ra
	
setCapitals:
	beq $t9, $t8, capitalsDone #when $t9 equals one ASCII after Z, finish the loop
	sb $t9, 0($t1) #store current ASCII value into current memory location
	addi $t9, 1 #increment ASCII value by 1
	addi $t1, 1 #increment memory pointer
	b setCapitals #loop
	
	capitalsDone:
		jr $ra

setLowers:
	beq $t9, $t8, lowersDone #when $t9 equals one ASCII after z, finish the loop
	sb $t9, 0($t1) #store current ASCII value into current memory location
	addi $t9, 1 #increment ASCII value by 1
	addi $t1, 1 #increment memory pointer
	b setLowers #loop
	
	lowersDone:
		jr $ra
		
setNumbers:
	beq $t9, $t8, numbersDone #when $t9 equals one ASCII after 9, finish the loop
	sb $t9, 0($t1) #store current ASCII value into current memory location
	addi $t9, 1 #increment ASCII value by 1
	addi $t1, 1 #increment memory pointer
	b setNumbers #loop
	
	numbersDone:
		jr $ra
		
setOthers:
	sb $t9, 0($t1) #store current ASCII value into current memory location(+)
	addi $t1, 1 #increment memory pointer
	li $t9, 47 #ascii value for /
	sb $t9, 0($t1) #store / into current memory location
	jr $ra
	
	
bigLoop:
	li $t6, 10 #load newline value into $t6
	lb $t2, 0($t0) #load 1st byte from input string into $t2
	beq $t2, $t6, doneBigLoop #branch out of loop if newline character
	addi $t0, 1 #increment string pointer by 1
	lb $t3, 0($t0) #load 2nd byte into $t3
	addi $t0, 1 #increment string pointer by 1
	lb $t4, 0($t0) #load 3rd byte into $t4
	addi $t0, 1 #increment string pointer by 1
	lb $t5, 0($t0) #load 4th byte into $t5
	addi $t0, 1 #increment string pointer by 1
	
	move $t1, $s1 #initializing alphabet pointer to start of alphabet
	li $t9, 0 # counter for alphabet value
	lb $t8, 0($t1)# loads first value in alphabet into $t8
	
	alphaLoop1: #inner loop for getting alphabet values for first byte
		beq $t8, $t2, doneFirst #branch out of loop if input byte equals current alphabet value
		addi $t1, 1 #increment memory address in alphabet
		lb $t8, 0($t1) #load new byte into #t8
		addi $t9, 1 #increment alphabet value counter by 1
		b alphaLoop1
		
		doneFirst:
			move $s2, $t9 #save the index from alphabet into $s2
			move $t1, $s1 #initializing alphabet pointer to start of alphabet
			li $t9, 0 # counter for alphabet value
			lb $t8, 0($t1)# loads first value in alphabet into $t8
			b alphaLoop2
			
	alphaLoop2: #inner loop for getting alphabet values for 2nd byte
		beq $t8, $t3, doneSecond #branch out of loop if input byte equals current alphabet value
		addi $t1, 1 #increment memory address in alphabet
		lb $t8, 0($t1) #load new byte into #t8
		addi $t9, 1 #increment alphabet value counter by 1
		b alphaLoop2
		
		doneSecond:
			move $s3, $t9 #save the index from alphabet into $s3
			move $t1, $s1 #initializing alphabet pointer to start of alphabet
			li $t9, 0 # counter for alphabet value
			lb $t8, 0($t1)# loads first value in alphabet into $t8
			b alphaLoop3
			
	alphaLoop3:
		beq $t8, $t4, doneThird #branch out of loop if input byte equals current alphabet value
		addi $t1, 1 #increment memory address in alphabet
		lb $t8, 0($t1) #load new byte into #t8
		addi $t9, 1 #increment alphabet value counter by 1
		b alphaLoop3
		
		doneThird:
			move $s4, $t9 #save the index from alphabet into $s4
			move $t1, $s1 #initializing alphabet pointer to start of alphabet
			li $t9, 0 # counter for alphabet value
			lb $t8, 0($t1)# loads first value in alphabet into $t8
			b alphaLoop4
			
	alphaLoop4:
		beq $t8, $t5, doneAll #branch out of loop if input byte equals current alphabet value
		addi $t1, 1 #increment memory address in alphabet
		lb $t8, 0($t1) #load new byte into #t8
		addi $t9, 1 #increment alphabet value counter by 1
		b alphaLoop4
		
doneAll: #this starts the code after the alphabet values have been recieved from the inner loops
	move $s5, $t9 #save the index from alphabet into $s5
	li $t9, 2 #put a 2 into $t9
	li $t2, 2 #put a 2 into $t2
	li $t3, 4 #put a 4 into $t4
	sllv $t4, $s2, $t2 #shift left logical character 1 (2 bits) and put value into $t4
	srlv $t5, $s3, $t3 #shift right logical character 2 (4 bits) and put value into $t5
	or $t4, $t4, $t5 #or $t4 and $t5 and store value back in $t4
	addi $t2, 2 #add 2 to $t2
	sub $t3, $t3, $t9 #subtract 2 from $t3
	sllv $t5, $s3, $t2 #shift left logical character 2 (4 bits) and put value into $t5
	srlv $t6, $s4, $t3 #shift right logical character 2 (2 bits) and put value into $t6
	or $t5, $t5, $t6 #or $t5 and $t6 and put result into $t5
	addi $t2, 2 #add 2 from $t2
	sub $t3, $t3, $t9 #subtract 2 from $t3
	sllv $t6, $s4, $t2 #shift left logical character 2 (6 bits) and put value into $t6
	srlv $t7, $s5, $t3 #shift right logical character 2 (0 bits) and put value into $t7
	or $t6, $t6, $t7 # or $t6 and $t7 and put result into $t6
	sb $t4, 0($s7) #store first bitstring into current location in output string
	addi $s7, 1 #increment output string pointer by 1
	sb $t5, 0($s7) #store second bitstring into current location in output string
	addi $s7, 1 #increment output string pointer by 1
	sb $t6, 0($s7) #store third bitstring into current location in output string
	addi $s7, 1 #increment output string pointer by 1
	b bigLoop #continue loop until newline character is reached
	
doneBigLoop:
	li $v0, 4 #printstr
	la $a0, Output #load output into $a0
	syscall
	move $a0, $s8 #move memory location of decoded string into $a0
	syscall
	la $a0, Newline #prints newline
	syscall
	syscall
	syscall
	jr $ra #return to main after call
	
	
end:
	li $v0, 4
	la $a0, Bye
	syscall
	li $v0, 10
	syscall
	
