	.data
Prompt: .asciiz "\n Please enter a positive integer. "
Error:	.asciiz "\n This is not a positive integer. Please try again. "
ResultOff: .asciiz "\n The last light is off."
ResultOn: .asciiz "\n The last light is on."
Bye: 	.asciiz "\n Have a nice day. "
		.globl main
		.text
	
main:
		la $a0, Prompt
		li $v0, 4
		syscall
Loop:
		li $s1, 1
		li $v0, 5
		syscall
		beq $v0, $0, End #branch to end if user enters 0
		bltz $v0, Bad #branch to bad if user enters negative number
		b Good #branch to good if neither of the above to are true
Bad:
		li $v0, 4
		la $a0, Error
		syscall
		b Loop #branch to loop to get another integer
Good:
		move $s0, $v0 #moves good int from v0 to s0
		li $t0, 0 #loads initial trip number into t0
Trips:
		addi $t0, 1
		bgt $t0, $s0, Done
		div $s0, $t0 #divides users entered int by trip number to see if divisable
		mfhi $t1 # puts remainder in t1 to check if divisable 
		beq $t1, $0, Flip
		b Trips
		
Flip:
		neg $s1, $s1
		b Trips
		
Done:
		bltz $s1, On
		bgtz $s1, Off
Off:
		la $a0, ResultOff
		li $v0, 4
		syscall
		b main
On:
		la $a0, ResultOn
		li $v0, 4
		syscall
		b main
End:	
		li $v0, 4
		la $a0, Bye
		syscall
		li $v0, 10
		syscall
		
		
		
		


