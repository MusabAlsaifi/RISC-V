/*
Musab Alsaifi
*/
.data
prompt_b:	.string		"Enter the value for Blue value: "
prompt_g:	.string		"Enter the valur for Green value: "
prompt_r: 	.string		"Enter the value for Red value: "
prompt_dx:	.string		"Enter the dx direction: "
prompt_dy:	.string 	"Enter the dy direction: "

.eqv    WIDTH 		512
.eqv    HEIGHT 		256
.eqv    PRINT_STR 	4
.eqv    READ_INT 	5
.eqv    EXIT_0      10
.eqv    ADDRESS 	268697600
.eqv    SLEEP       32

.text
	#print prompt_r 
	li		a7, PRINT_STR
	la		a0, prompt_r
	ecall
	
	#read and store the value for Red
	li		a7, READ_INT	
	ecall
    slli    s0, a0, 16
	
	#print prompt_g 
	li		a7, PRINT_STR
	la		a0, prompt_g
	ecall
	
	#read and store the value for Grean
	li		a7, READ_INT
	ecall
    slli    a0, a0, 8
	add 	s0, s0, a0
	
	#print prompt_b
	li		a7, PRINT_STR
	la		a0, prompt_b
	ecall
	
	#read and store the value for Blue
	li		a7, READ_INT
	ecall
    #slli    a0, a0, 8
	add 	s0, s0, a0

	#print prompt_dx
	li		a7, PRINT_STR
	la		a0, prompt_dx
	ecall
	
	#read and store the value for dx
	li		a7, READ_INT
	ecall
	mv 		s3, a0

	#print prompt_dy
	li		a7, PRINT_STR
	la		a0, prompt_dy
	ecall
	
	#read and store the value for dy
	li		a7, READ_INT
	ecall
	mv 		s4, a0

	li 		s5, ADDRESS
    #bytes per line
	li		t0, WIDTH	
	slli	t0, t0, 2

    #number of lines to skip to get to the middle line
	li		t1, HEIGHT
	srli 	t1, t1, 1
    mv      s6, t1
	li		t2, -1

#number of divisions to go to the middle of the height. So, if height is 256, then half of it is 128 which is 2^7
loop:
	beqz	t1, middle
	srli	t1, t1, 1
	addi	t2, t2, 1
	j		loop

#go to the middle of the height  
middle:
	sll		t3, t0, t2		#t0 * 7, so now we are at the right of middle screen
	li		t1, WIDTH
	slli	t1, t1, 1		#divide width by 2
	sub		t3, t3, t1		#substract half of the width to go to the middle of the screen (0, 0)
	add 	s5, s5, t3		#go to point (0, 0) which is the middle of the screen

    li      s7, WIDTH	
    srli    s7, s7, 1		#store in s7 half of the width cz we need to use it later

#implementation of bresenham algorithm
	sub		t2, s4, s3 		#e
    slli    t2, t2, 1
    li      t3, 0       	#x
    li      t4, 0       	#y
    li      t5, 4
    li      a7, SLEEP
    li      a0, EXIT_0

neg_x:
	bgtz	s3, neg_y
	neg 	t5, t5
    neg     s3, s3

neg_y:
	bgtz	s4, while
	neg 	t0, t0
    neg     s4, s4

while:
    bne     t4, s6, check_x
    neg     t4, t4
    neg     t0, t0

check_x:
    bne     t3, s7, draw
    neg     t3, t3
    neg     t5, t5

if:
	bltz 	t2, cont
	sub     s5, s5, t0
    addi    t4, t4, 1
	sub		t2, t2, s3
    j       while

cont:
    addi    t3, t3, 1
	add	    s5, s5, t5
    add     t2, t2, s4
	j		while

#Drawing pixal
draw:
    ecall
	sw 		s0, (s5)
	j       if

exit:
	li	    a7, EXIT_0
	ecall
    
    
