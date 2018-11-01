	.data
Promptx1: .asciiz "\n Please enter a floating point number for x1. "
Prompty1: .asciiz "\n Please enter a floating point number for y1. "
Promptx2: .asciiz "\n Please enter a floating point number for x2. "
Prompty2: .asciiz "\n Please enter a floating point number for y2. "
resultc: .asciiz "\n The area of the circle is "
results: .asciiz "\n The area of the square is "
resultr: .asciiz "\n The area of the rectangle is "
bye: .asciiz "\n Have a nice day."
PI:	.double	3.1416

	.text
	.globl main

main:
		l.d $f16, PI
		li $v0, 4
		la $a0, Promptx1
		syscall
		li $v0, 7
		syscall
		mov.d $f2, $f0
		li $v0, 4
		la $a0, Prompty1
		syscall
		li $v0, 7
		syscall
		mov.d $f4, $f0
		li $v0, 4
		la $a0, Promptx2
		syscall
		li $v0, 7
		syscall
		mov.d $f6, $f0
		li $v0, 4
		la $a0, Prompty2
		syscall
		li $v0, 7
		syscall
		mov.d $f8, $f0
		
		jal circle
		jal square
		jal rectangle
		
		b end
		
circle:
		la $s0, getlength
		jalr $s1, $s0
		la $s2, getsquare
		jalr $s3, $s2
		la $s0, areacircle
		jalr $s1, $s0
		la $a0, resultc
		li $v0, 4
		syscall
		li $v0, 3
		syscall
		jr $ra
square:
		la $s0, getlength
		jalr $s1, $s0
		la $s2, getsquare
		jalr $s3, $s2
		la $s0, areasquare
		jalr $s1, $s0
		la $a0, results
		li $v0, 4
		syscall
		li $v0, 3
		syscall
		jr $ra
rectangle:
		la $s0, getlength
		jalr $s1, $s0
		la $s0, arearectangle
		jalr $s1, $s0
		la $a0, resultr
		li $v0, 4
		syscall
		li $v0, 3
		syscall
		jr $ra
getlength:
		sub.d $f10, $f6, $f2
		sub.d $f12, $f8, $f4
		jr $s1
getsquare:
		mul.d $f10, $f10, $f10
		mul.d $f12, $f12, $f12
		add.d $f10, $f10, $f12
		jr $s3
areacircle:
		mul.d $f12, $f10, $f16		
		jr $s1
areasquare:
		mov.d $f12, $f10
		jr $s1
arearectangle:
		mul.d $f12, $f10, $f12
		jr $s1
end:
		li $v0, 4
		la $a0, bye
		syscall
		li $v0, 10
		syscall
		
	