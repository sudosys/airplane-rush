# Airplane Rush Game

# Display Attributes
.eqv DISPLAY_WIDTH 512
.eqv DISPLAY_HEIGHT 256
.eqv ORIGIN 0x10010000

# Plane Attributes
.eqv PLANE_WIDTH 100
.eqv PLANE_HEIGHT 50
.eqv PLANE_X_COORD 40
.eqv PLANE_UP_COORD 20
.eqv PLANE_MID_COORD 100
.eqv PLANE_DOWN_COORD 180

# Buttons
.eqv W_BUTTON 119
.eqv S_BUTTON 115
.eqv SPC_BUTTON 32

.macro sleep_100ms
li $v0, 32
li $a0, 100
syscall
.end_macro

.macro sleep_10ms
li $v0, 32
li $a0, 10
syscall
.end_macro

# Bird Attributes
.eqv BIRD_SIZE 25
.eqv BIRD_X_COORD 400
.eqv BIRD_UP_COORD 30
.eqv BIRD_MID_COORD 110
.eqv BIRD_DOWN_COORD 190

# Health Kit Attributes
.eqv HEALTH_KIT_SIZE 25
.eqv HEALTH_KIT_X_COORD 400
.eqv HEALTH_KIT_UP_COORD 30
.eqv HEALTH_KIT_MID_COORD 110
.eqv HEALTH_KIT_DOWN_COORD 190

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
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal draw_sky

	li $a2, PLANE_MID_COORD	
	jal draw_plane
	
	li $t9, 0
	#jal listen_button
	
	add $s6, $s6, 1
	
	li $s4, BIRD_UP_COORD
	li $s5, BIRD_MID_COORD
	jal bird_wave
	
	li $s4, BIRD_MID_COORD
	li $s5, BIRD_DOWN_COORD
	jal bird_wave
	
	li $s4, BIRD_UP_COORD
	li $s5, BIRD_MID_COORD
	jal bird_wave	
	
	li $s4, BIRD_MID_COORD
	li $s5, BIRD_DOWN_COORD
	jal bird_wave
	
	li $s4, BIRD_UP_COORD
	li $s5, BIRD_DOWN_COORD
	jal bird_wave
	
	jal draw_buse_yilmaz_castle
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	li $v0, 10
	syscall

draw_sky:
	
	addi $t3, $zero, CYAN
	addi $t4, $zero, 0x20000 # 0x20000 is 512*256 in hex
	la $t5, ORIGIN
	
	draw_sky_loop:
		sw $t3, 0($t5)
		subi $t4, $t4, 1
		addi $t5, $t5, 4
		bnez $t4, draw_sky_loop		

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

# Arguments: $a2 = Plane's y axis
draw_plane:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, GREEN
	li $a0, PLANE_X_COORD
	li $a1, PLANE_WIDTH
	li $a3, PLANE_HEIGHT
	
	jal draw_object
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

draw_bird:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, YELLOW
	li $a1, BIRD_SIZE
	li $a3, BIRD_SIZE
	
	jal draw_object
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

draw_health_kit:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, RED
	li $a1, HEALTH_KIT_SIZE
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

listen_button:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	pool_loop:
		lw $t0, 0xffff0000
		li $s0, W_BUTTON
		li $s1, S_BUTTON
		li $s2, SPC_BUTTON
		
		andi $t0, $t0, 0x0001
		beq $t0, $zero, pool_loop
	
	lw $t1, 0xffff0004
	
	beq $s0, $t1, w_button_pressed
	beq $s1, $t1, s_button_pressed
	#beq $s2, $t1, game_begin

	lw $ra, 0($sp)
	addiu, $sp, $sp, 4

	j listen_button
	
w_button_pressed:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	bge $t9, 1, return_back_w

	addiu $t9, $t9, 1
	
	beq $t9, $zero, draw_mid_w
	beq $t9, 1, draw_upper_w
	
	draw_mid_w: 
		li $a2, PLANE_DOWN_COORD
		jal plane_relocate
		
		li $a2, PLANE_MID_COORD
		jal draw_plane
		
		j return_back_w
	
	draw_upper_w:
		li $a2, PLANE_MID_COORD
		jal plane_relocate
	
		li $a2, PLANE_UP_COORD
		jal draw_plane
		
		j return_back_w
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	return_back_w: jal listen_button

s_button_pressed:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	ble $t9, -1, return_back_s

	addiu $t9, $t9, -1
	
	beq $t9, $zero, draw_mid_s
	
	beq $t9, -1, draw_lower_s
	
	draw_mid_s:
		li $a2, PLANE_UP_COORD
		jal plane_relocate
	
		li $a2, PLANE_MID_COORD
		jal draw_plane
		
		j return_back_s
	
	draw_lower_s:
		li $a2, PLANE_MID_COORD
		jal plane_relocate
	
		li $a2, PLANE_DOWN_COORD
		jal draw_plane
		
		j return_back_s
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	return_back_s: jal listen_button

#game_begin:
		

# Arguments: $a2 = Plane's y axis
plane_relocate:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, CYAN
	li $a0, PLANE_X_COORD
	li $a1, PLANE_WIDTH
	li $a3, PLANE_HEIGHT
	
	jal draw_object
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

# Arguments: $a0 = Bird's x axis, $a2 = Bird's y axis
bird_relocate:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, CYAN
	li $a1, BIRD_SIZE
	li $a3, BIRD_SIZE
	
	jal draw_object
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

# Arguments: $a0 = Health Kit's x axis, $a2 = Health Kit's y axis
health_kit_relocate:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, CYAN
	li $a1, HEALTH_KIT_SIZE
	li $a3, HEALTH_KIT_SIZE
	
	jal draw_object
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

# Arguments: $s4 = Bird 1's y axis, $s5 = Bird 2's y axis
bird_wave:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $t0, BIRD_X_COORD
	li $t8, HEALTH_KIT_X_COORD
	
	li $s3, 13 # Bird movement limit
	add $t5, $t5, $zero # Bird 1 movement iteration
	add $t6, $t6, $zero # Bird 2 movement iteration
	
	move_loop:
		
		# Draw Bird 1
		move $a2, $s4	
		move $a0, $t0
				
		jal draw_bird
		
		sleep_10ms
		
		# Draw Bird 2
		move $a2, $s5		
		move $a0, $t0
				
		jal draw_bird
		
		# Relocate Bird 1
		move $a2, $s4		
		move $a0, $t0
		
		jal bird_relocate
		
		sleep_10ms

		# Relocate Bird 2
		move $a2, $s5	
		move $a0, $t0
		
		jal bird_relocate

		subi $t0, $t0, 30
		
		sleep_100ms
		
		# Redraw Bird 1
		move $a2, $s4
		move $a0, $t0
		
		jal draw_bird
		
		sleep_10ms
		
		# Redraw Bird 2
		move $a2, $s5
		move $a0, $t0
		
		jal draw_bird
		
		beq $s6, 3, draw_hkit
		j dont_draw_hkit
		
		draw_hkit:
			move $a0, $t8
			li $a2, HEALTH_KIT_DOWN_COORD
			jal draw_health_kit
			
			move $a0, $t8
			li $a2, HEALTH_KIT_DOWN_COORD
			jal health_kit_relocate
			
			subi $t8, $t8, 30
			
			move $a0, $t8
			li $a2, HEALTH_KIT_DOWN_COORD
			jal draw_health_kit
		
		dont_draw_hkit:
		
			subi $s3, $s3, 1
			addi $t5, $t5, 1
			addi $t6, $t6, 1
		
		bnez $s3, move_loop
	
	addi $s6, $s6, 1
	
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
