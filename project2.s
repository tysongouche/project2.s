.data 									      #data section starts
	input: .space 1001					      #Reserve 1001 bytes for input
	final_string: .space 4
	error: .asciiz "Not recognized"	

.text 									#text section starts
	
main: 									#Main Section Starts
	li $v0, 8							#Load Read input command
	la $a0, input						#Mem Address from input is now destination MA
	syscall

	li $t0, 0							#This register will be used for byte addressing
	li $t9, 0 							#This register will be used for len of final string
lead:
	slti $t3, $t9, 5  					#Test to see if len of final string is < 5
	beq $t3, $zero, end_program
	la $a0, final_string
	lbu $t1, input($t0)					#Load byte from input into t1 register
	
	addi $t8, $zero, 32					#Temporarily holds the space character
	beq $t8, $t1, bad_lead_char			#Test to see if lead byte is a space char
	addi $t8, $zero, 9					#Temporarily holds the tab character
	beq $t8, $t1, bad_lead_char			#Test to see if lead byte is a tab char
