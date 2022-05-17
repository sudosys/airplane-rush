# Airplane Rush Game

# Display Attributes
.eqv DISPLAY_WIDTH 512
.eqv DISPLAY_HEIGHT 256
.eqv ORIGIN 0x10010000

# Plane Attributes
.eqv PLANE_WIDTH 100
.eqv PLANE_HEIGHT 50
.eqv PLANE_X_COORD 20
.eqv PLANE_UP_COORD 20
.eqv PLANE_MID_COORD 100
.eqv PLANE_DOWN_COORD 180

# Colors
.eqv CYAN 0x0000FFFF # Sky
.eqv GREEN 0x0000FF00 # Plane
.eqv YELLOW 0x00FFFF00 # Birds
.eqv RED 0x00FF0000 # Fuel tanks

.text

main:

	jal draw_sky
	
	jal draw_plane
	
	li $v0, 10
	syscall

draw_sky:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $t3, $zero, CYAN
	addi $t4, $zero, 0x20000 # 0x20000 is 512*256 in hex
	la $t5, ORIGIN
	
	draw_sky_loop:
		sw $t3, 0($t5)
		subi $t4, $t4, 1
		addi $t5, $t5, 4
		bnez $t4, draw_sky_loop		

	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

# Parameters: $a0: x_coordinate, $a1: width, $a2: y_coordinate, $a3: height
draw_object:

	la $t1, ORIGIN

	add $a1, $a1, $a0
	add $a3, $a3, $a2
	
	sll $a0, $a0, 2
	sll $a1, $a1, 2
	sll $a2, $a2, 11
	sll $a3, $a3, 11
	
	addu $t2, $a2, $t1
	addu $a3, $a3, $t1
	addu $a2, $t2, $a0
	addu $a3, $a3, $a0
	addu $t2, $t2, $a1
	
	li $t4, 0x800
	
	draw_object_y_axis:
		add $t3, $zero, $a2
	
		draw_object_x_axis:
			sw $s0, 0($t3)
			addi $t3, $t3, 4
			bne $t3, $t2, draw_object_x_axis
		
		addu $a2, $a2, $t4
		addu $t2, $t2, $t4
		bne $a3, $a2, draw_object_y_axis
	
	jr $ra

draw_plane:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, GREEN
	li $a0, PLANE_X_COORD
	li $a1, PLANE_WIDTH
	li $a2, PLANE_MID_COORD
	li $a3, PLANE_HEIGHT
	
	jal draw_object
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

# Parameters: $a0 = x_coordinate, $a1 = y_coordinate
calc_pixel_addr:
	
	# Formula: ORIGIN + 4 * (x_coordinate + y_coordinate * DISPLAY_WIDTH)

	addiu $t0, $zero, DISPLAY_WIDTH
	mul $t1, $t0, $a1
	addu $t2, $t1, $a0
	sll $t2, $t2, 2
	addiu $v0, $t2, ORIGIN
	
	jr $ra
