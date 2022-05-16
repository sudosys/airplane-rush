# Airplane Rush Game

# Display Attributes
.eqv WIDTH 512
.eqv HEIGHT 256
.eqv ORIGIN 0x10010000

# Colors
.eqv CYAN 0x0000FFFF # Sky
.eqv BLUE 0x000000FF # Plane
.eqv YELLOW 0x00FFFF00 # Birds
.eqv RED 0x00FF0000 # Fuel tanks

.text

main:

	jal draw_sky
	
	li $v0, 10
	syscall

draw_sky:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $t3, $zero, CYAN
	addi $t4, $zero, 0x20000 # 0x20000 is 512*256 in hex
	la $t5, ORIGIN
	
	draw_loop:
		sw $t3, 0($t5)
		subi $t4, $t4, 1
		addi $t5, $t5, 4
		bnez $t4, draw_loop		

	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

# Parameters: $a0 = x_coordinate, $a1 = y_coordinate
calc_pixel_addr:
	
	# Formula: ORIGIN + 4 * (x_coordinate + y_coordinate * WIDTH)

	addiu $t0, $zero, WIDTH
	mul $t1, $t0, $a1
	addu $t2, $t1, $a0
	sll $t2, $t2, 2
	addiu $v0, $t2, ORIGIN
	
	jr $ra
