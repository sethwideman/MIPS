##############################################
# Program Name: Assignment 2
# Programmer: Ryan Taylor
# Date 10/2/17
#############################################
# Functional Description:
# A program to determine if two string are equal and then print both strings combined
# Input:
# User inputs 2 strings to be compared
############################################

.data	# Data declaration section

Prompt: 	.asciiz "\nPlease enter two strings to be compared."
PromptS1:	.asciiz "\nString 1: "
PromptS2: 	.asciiz "\nString 2: "
DontMatch:	.asciiz "\nStrings do not match"
Match: 		.asciiz "\nThe strings are equal"
Bye: 		.asciiz "\n Thank you fo using my program and have a good day"
	.globl main
	.text

main: #Start of code section
	li		$v0, 4		#System call code for Print String
	la		$a0, Prompt	#load address of prompt into $a0
	syscall				#print the prompt message

	li		$v0, 4		#System call code for Print String
	la 		$a0, PromptS1#load prompt1
	syscall 			#call

	li $v0, 9 #move memory
	li $a0, 80 #ready 80 bits in $a0
	syscall

	move $t0, $v0 #string pointer 
	move $s0, $v0 #string head for string 1

	li $v0, 8 #ready for string input
	move $a0, $t0 #move t0 to a0
	li $a1, 80 #ready for 80 bits of input
	syscall #take input

	jal GetStringLength #go to string length calculator
	
	move $t2, $t7 #move string 1 length to t2
	
	li		$v0, 4		#System call code for Print String
	la 		$a0, PromptS2#load prompt1
	syscall 			#call
	
	li $v0, 9 #move memory
	li $a0, 80 #ready 80 bits in $a0
	syscall

	move $t0, $v0 #string pointer 
	move $s1, $v0 #string head for string 2

	li $v0, 8 #ready for string input
	move $a0, $t0 #move t0 to a0
	li $a1, 80 #ready for 80 bits of input
	syscall #take input
	
	jal GetStringLength #go to string length calculator
	
	move $t3, $t7 #move string 1 length to t2
	
	bne $t2, $t3, NoMatch #strings do not match
	jal CheckEquality #go to check equality function
	
	b End #End program
	
	NoMatch:
		li	$v0, 4	#System call code for Print String
		la 	$a0, DontMatch #load prompt1
		syscall 	#call
		b End #end program

CheckEquality:
	move $t0, $s0 #string pointer 1
	move $t1, $s1 #string pointer 1
	li $t7, 1 #start counter at 0
	LoopEq:
		lb $t4, 0($t0) #load character string 1 into t4
		lb $t5, 0($t1) #load character string 2 into t5
		bne $t4, $t5, NoMatch #branch to no match if not equal
		beq $t2, $t7, Equal #if counter is full branch to match
		addi $t0, $t0, 1 # increment the string pointer
		addi $t1, $t1, 1 # increment the string pointer
		addi $t7, $t7, 1 # increment the count
		b LoopEq #restart loop
	Equal:
		li	$v0, 4	#System call code for Print String
		la 	$a0, Match #load Match
		syscall 	#call
		jr $ra #go back to main
		


GetStringLength:
	li $t7, -1 #start counter at -1
	LoopLen:
		lb $t6, 0($t0) #load character into t6
		beq $t6, $0,  Finish #if null character go to finish
		addi $t0, $t0, 1 # increment the string pointer
		addi $t7, $t7, 1 # increment the count
		b LoopLen #restart loop
	Finish:
		jr $ra #go back to call
	


End:	li	$v0, 4	#System call code for Print String
	la	$a0, Bye	#load addrss of msg into $a0
	syscall		#print the string
	li	$v0, 10	#terminate program run and
	syscall		#return control to the system
