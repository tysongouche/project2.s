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

	addi $t8, $zero, 10   				#t8 temporarily holds the \n ascii code
	beq $t1, $t8, sub_program			#If current byte is \n, go to sub program	
	addi $t8, $zero, 64
	ble $t1, $t8, int_test				#Int test 
int_back:
	sb $t1, final_string($t9)			#if byte reaches here, save it to the final string
	addi $t9, $t9, 1 					#Increase len count of final string by 1
	addi $t0, $t0, 1   					#Increase current byet offset by 1

F_ADDER_LOOP: 
	lbu $t1, input($t0) 				#Load new current byte
	addi $t0, $t0, 1     				#TEMP Increase offset by 1 to hold next byte
	lbu $t2, input($t0)					#Load next byte	
	addi $t0, $t0, -1					#Set byte offset back to what it was
	addi $t8, $zero, 32 				#Test for trailing space
	beq $t1, $t8, spaceTab_test
	addi $t8, $zero, 9 					#Test for trailing tab
	beq $t1, $t8, spaceTab_test
	addi $t3, $zero, 90					#Test for Z (illegal letter)
	beq $t3, $t1, end_program			
	addi $t3, $zero, 122				#Test for z (illegal letter)
	beq $t3, $t1, end_program
	slti $t3, $t9, 5  					#Test to see if len of final string is < 5
	beq $t3, $zero, end_program
	beq $t1, $zero, sub_program			#If current byte is null, go to sub program
	addi $t8, $zero, 10   				#t8 temporarily holds the \n ascii code
 	beq $t1, $t8, sub_program			#If current byte is \n, go to sub program
	addi $t8, $zero, 32					#Temporarily holds the space character
	beq $t8, $t1, spaceTab_test			#Test to see if byte is a trailing space/tab
	addi $t8, $zero, 9					#Temporarily holds the tab character
	beq $t8, $t1, spaceTab_test			#Test to see if byte is a trailing space/tab
	slti $t3, $t1, 48					#Test if ascii value of current byte is < 0's ascii code
	bne $t3, $zero, end_program
