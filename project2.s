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
	addi $t3, $zero, 255				#<255 test
	beq $t1, $t3, end_program 
	slti $t3, $t1, 58					#Test 1 
	slti $t4, $t1, 65					#Test 1
	add $t4, $t4, $t3
	addi $t3, $zero, 1 
	beq $t4, $t3, end_program
	slti $t3, $t1, 91					#Test 2 
	slti $t4, $t1, 97					#Test 2
	add $t4, $t4, $t3
	addi $t3, $zero, 1 
	beq $t4, $t3, end_program
	slti $t3, $t1, 123					#Test 3 
	slti $t4, $t1, 255					#Test 3
	add $t4, $t4, $t3
	addi $t3, $zero, 1 
	beq $t4, $t3, end_program
	j add_byte						#Good bytes reach here
	
	
sub_print:
	add $a0, $zero, $v1
	li $v0, 1
	syscall
	li $v0, 10    						#End program
	syscall

	
sub_program:
	beq $t9, $zero, end_program
	addi $a0, $zero, 1 					#Giving A registers proper calculation values
	addi $a1, $zero, 35					#Giving A registers proper calculation values
	addi $a2, $zero, 1225				#Giving A registers proper calculation values
	addi $a3, $zero, 32767				#Giving A registers proper calculation values
		
	addi $t9, $t9, -1 					#Set byte addr offset back to 0
	lbu $t5, final_string($t9)			#load first byte from final string	
	
	slti $t3, $t5, 65					#Test for uppercase 
	slti $t4, $t5, 91					
	add $t4, $t4, $t3
	addi $t3, $zero, 1 
	beq $t4, $t3, uppercase1
	slti $t3, $t5, 97					#Test for lowercase
	slti $t4, $t5, 123					
	add $t4, $t4, $t3
	addi $t3, $zero, 1 
	beq $t4, $t3, lowercase1
	bne $t5, $zero, modify1				#Test for integer
here1:
uhere1:
lhere1:
	mult $a0, $t5						#convert it to hex
	mflo $s0
	mfhi $s1
	add $v0, $zero, $s0
	add $v0, $v0, $s1

	addi $t9, $t9, -1 					#Increase byte addr offset by 1
	lbu $t6, final_string($t9)			#load 2nd byte from final string
	slti $t3, $t6, 65					#Test for uppercase 
	slti $t4, $t6, 91					
	add $t4, $t4, $t3
	addi $t3, $zero, 1 
	beq $t4, $t3, uppercase2
	slti $t3, $t6, 97					#Test for lowercase
	slti $t4, $t6, 123					
	add $t4, $t4, $t3
	addi $t3, $zero, 1 
	beq $t4, $t3, lowercase2
	bne $t6, $zero, modify2				#Test for integer
here2:
uhere2:
lhere2:
	mult $a1, $t6						#convert it to hex
	mflo $s0
	mfhi $s1
	add $v0, $v0, $s0
	add $v0, $v0, $s1
	
	addi $t9, $t9, -1 					#Increase byte addr offset by 1
	lbu $t7, final_string($t9)			#load 3rd byte from final string
	slti $t3, $t7, 65					#Test for uppercase 
	slti $t4, $t7, 91					
	add $t4, $t4, $t3
	addi $t3, $zero, 1 
	beq $t4, $t3, uppercase3
	slti $t3, $t7, 97					#Test for lowercase
	slti $t4, $t7, 123					
	add $t4, $t4, $t3
	addi $t3, $zero, 1 
	beq $t4, $t3, lowercase3	
	bne $t7, $zero, modify3				#Convert byte into its true value
here3:
uhere3:
lhere3:
	mult $a2, $t7						#convert it to hex
	mflo $s0
	mfhi $s1
	add $v0, $v0, $s0
	add $v0, $v0, $s1	
	
	addi $t9, $t9, -1 					#Increase byte addr offset by 1
	lbu $t8, final_string($t9)			#load 4th byte from final string
	slti $t3, $t8, 65					#Test for uppercase 
	slti $t4, $t8, 91					
	add $t4, $t4, $t3
	addi $t3, $zero, 1 
	beq $t4, $t3, uppercase4
	slti $t3, $t8, 97					#Test for lowercase
	slti $t4, $t8, 123					
	add $t4, $t4, $t3
	addi $t3, $zero, 1 
	beq $t4, $t3, lowercase4	
	bne $t8, $zero, modify4				#Convert byte into its true value
here4:
uhere4:
lhere4:
	mult $a3, $t8						#convert it to hex
	mflo $s0
	mfhi $s1
	add $v0, $v0, $s0
	add $v0, $v0, $s1
	addi $a3, $zero, 10108
	mult $a3, $t8						#second half of too big number
	mflo $s0
	mfhi $s1
	add $v0, $v0, $s0
	add $v0, $v0, $s1
	
	add $v1, $zero, $v0					#Put answer in v1
	j sub_print


#Branch Destinations
int_test: 
	slti $t3, $t1, 48					#Test for number 
	slti $t4, $t1, 58					
	add $t4, $t4, $t3
	addi $t3, $zero, 1 
	bne $t4, $t3, end_program
	j int_back

add_byte:
	sb $t1, final_string($t9)				#Save byte to final string
	addi $t9, $t9, 1 					#Increase len count of final string by 1
	addi $t0, $t0, 1   					#Increase current byet offset by 1
	j F_ADDER_LOOP

bad_lead_char:
	addi $t0, $t0, 1   					#Increase current byet offset by 1
	j lead

spaceTab_test:
	slti $t3, $t9, 5  					#Test to see if len of final string is < 5
	beq $t3, $zero, end_program
	addi $t8, $zero, 9 					#Final Test for tab
	beq $t2, $t8, sub_program			
	addi $t8, $zero, 32 				#Final Test for space
	beq $t2, $t8, sub_program			
	addi $t8, $zero, 10 				#Final Test for \n
	beq $t2, $t8, sub_program			
	j end_program						#If it reaches here, byte was illegal

end_program:
	li $v0, 4
	la $a0, error						#Print "Not recognized"
	syscall
	li $v0, 10    						#End program
	syscall
	
modify1:								#modify numbers
	addi $t5, $t5, -48
	j here1
	
modify2:
	addi $t6, $t6, -48
	j here2

modify3:
	addi $t7, $t7, -48
	j here3

modify4:
	addi $t8, $t8, -48
	j here4

uppercase1:								#Modify Letters
	addi $t5, $t5, -55
	j uhere1
	
lowercase1:
	addi $t5, $t5, -87
	j lhere1

uppercase2:								
	addi $t6, $t6, -55
	j uhere2

lowercase2:
	addi $t6, $t6, -87
	j lhere2
	
uppercase3:								
	addi $t7, $t7, -55
	j uhere3
	
lowercase3:
	addi $t7, $t7, -87
	j lhere3
	
