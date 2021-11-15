.data 									      #data section starts
	input: .space 1001					      #Reserve 1001 bytes for input
	final_string: .space 4
	error: .asciiz "Not recognized"	

.text 									#text section starts
	
main: 									#Main Section Starts
	li $v0, 8							#Load Read input command
	la $a0, input						#Mem Address from input is now destination MA
	syscall
