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

.macro sleep_10ms
li $v0, 32
li $a0, 10
.end_macro

# Bird Attributes
.eqv BIRD_SIZE 25

# Health Kit Attributes
.eqv HEALTH_KIT_SIZE 25

# Buse Yýlmaz Castle Attributes
.eqv CASTLE_WIDTH 25
.eqv CASTLE_HEIGHT 256
.eqv CASTLE_X_COORD 487
.eqv CASTLE_Y_COORD 0

# Colors
.eqv CYAN 0x0000FFFF # Sky
.eqv GREEN 0x0000FF00 # Plane
.eqv YELLOW 0x00FFFF00 # Birds
.eqv RED 0x00FF0000 # Health Kit
.eqv MAGENTA 0x00FF00FF # Buse Yýlmaz Castle

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

draw_bird:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, YELLOW
	li $a0, 200
	li $a1, BIRD_SIZE
	li $a2, 90
	li $a3, BIRD_SIZE
	
	jal draw_object
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

draw_health_kit:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, RED
	li $a0, 200
	li $a1, HEALTH_KIT_SIZE
	li $a2, 90
	li $a3, HEALTH_KIT_SIZE
	
	jal draw_object
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

draw_buse_yilmaz_castle:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, MAGENTA
	li $a0, CASTLE_X_COORD
	li $a1, CASTLE_WIDTH
	li $a2, CASTLE_Y_COORD
	li $a3, CASTLE_HEIGHT
	
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
