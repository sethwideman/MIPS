####################################
#Seth Wideman
#Lab4
####################################


	.data
Prompt: .asciiz "\n Enter a value to see if it is in the sets. "
set1: .asciiz "\n Values in the first set \n"
set2: .asciiz "\n Values in the second set \n"
union: .asciiz "\n Values in the unions of the sets \n"
intersection: .asciiz "\n Values in the intersection of the sets \n"
inset1true: .asciiz "\n The value you entered is in the first set."
inset2true: .asciiz "\n The value you entered is in the second set."
inset1false: .asciiz "\n The value you entered is not in the first set."
inset2false: .asciiz "\n The value you entered is not in the second set."
bye: .asciiz "\n Have a good day!"
	.text
	.globl main
	
main:
		li $s0, 0xaaaaaaaa
		li $s1, 0x24924924
		li $t0, 0 # load 0 (counter) into t0
		li $t1, 1 # register to and bitstring to
		li $v0, 4 #load print string
		la $a0, Prompt #load prompt to print
		syscall #prints prompt
		li $v0, 5 #read integer
		syscall
		move $s7, $v0 #storing value to check in s7
		move $t4, $s0 #moving first bitstring into t4
		li $v0, 4 #printstr
		la $a0, set1
		syscall
		jal printset #jump to printset function
		jal reset #function to reset counter and logic register
		move $t4, $s1 #moving second bitstring to t4
		li $v0, 4 #printstr
		la $a0, set2
		syscall
		jal printset
		jal checkvalue
		jal reset #reset counter and logic
		or $t4, $s0, $s1
		li $v0, 4 #printstr
		la $a0, union
		syscall
		jal printset
		jal reset
		and $t4, $s1, $s0
		li $v0, 4 #printstr
		la $a0, intersection
		syscall
		jal printset
		b end
		
printset:
		and $s2, $t4, $t1 #and bitstring with position and store in s2
		sll $t1, $t1, 1 #shift bit left one place
		addi $t0, $t0, 1 #add 1 to the counter
		beq $t0, 33, return #return to main if counter has reached end of string
		bne $s2, $0, print #branch to print if s2 doesnt equal 0
		b printset
		
		print:
			li $v0, 1 #print integer
			move $a0, $t0 #moving value in counter to be printed
			syscall
			li $a0, 32 #ascii code for space
			li $v0, 11 #print character
			syscall
			beq $s7, $t0, valuefound
			b printset
			
			valuefound:
				beq $t4, $s0 first
				beq $t4, $s1, second
				first:
					li $t5, 1 #load a 1 into $t5
					b printset #loop back to printset
				second:
					li $t6, 1 #load a 1 into $t6
					b printset #loop back to printset
			
		return:
			jr $ra #return to main after function
			
checkvalue:
		beq $t5, 1, yesfirst
		bne $t5, 1, nofirst
		yesfirst:
			li $v0, 4 #printstr
			la $a0, inset1true #load address
			syscall
			beq $t6, 1, yessecond
			bne $t6, 1, nosecond
		nofirst:
			li $v0, 4 #printstr
			la $a0, inset1false #load address
			syscall
			beq $t6, 1, yessecond
			bne $t6, 1, nosecond
		yessecond:
			li $v0, 4 #printstr
			la $a0, inset2true #load address
			syscall
			jr $ra
		nosecond:
			li $v0, 4 #printstr
			la $a0, inset2false #load address
			syscall
			jr $ra
			
			
reset:
		li $t0, 0 #reset counter to 0
		li $t1, 1 #reset logic register to 1
		jr $ra #return to main
			
end: 
		li $v0, 4 # print string
		la $a0, bye # load address bye to print
		syscall
		li $v0, 10 #terminate
		syscall
		
		
		