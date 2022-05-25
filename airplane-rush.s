# Airplane Rush Game

##Bitmap Display Settings## 
# Unit Width: 1
# Unit Height: 1
# Display Width: 512
# Display Height: 256
# Base Address: Static Data
############################

######Game Information######
# Green object is the plane
# Yellow objects are the birds
# Red objects are the health kits
# Purple building is the Buse Yılmaz Castle
# Pressing SPACE will start the game
# Plane can be controlled with 'w' and 's' keys
# Plane has total of 2 health points
# If you hit a bird, you lose 1 health point
# Health kit gives you 1 health point
# Enjoy! ;)
############################

# Display Attributes
.eqv DISPLAY_WIDTH 512
.eqv DISPLAY_HEIGHT 256
.eqv ORIGIN 0x10010000

# Plane Attributes
.eqv PLANE_WIDTH 100
.eqv PLANE_HEIGHT 50
.eqv PLANE_X_COORD 30
.eqv PLANE_UP_COORD 20
.eqv PLANE_MID_COORD 100
.eqv PLANE_DOWN_COORD 180

# Buttons
.eqv W_BUTTON 119
.eqv S_BUTTON 115
.eqv SPC_BUTTON 32

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

# Buse Y�lmaz Castle Attributes
.eqv CASTLE_WIDTH 25
.eqv CASTLE_HEIGHT 256
.eqv CASTLE_X_COORD 487
.eqv CASTLE_Y_COORD 0

# Colors
.eqv CYAN 0x0000FFFF # Sky
.eqv GREEN 0x0000FF00 # Plane
.eqv YELLOW 0x00FFFF00 # Birds
.eqv RED 0x00FF0000 # Health Kit
.eqv MAGENTA 0x00FF00FF # Buse Y�lmaz Castle

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

.macro print_health
li $v0, 1
add $a0, $zero, $t6
syscall
.end_macro

.data

welcome_text: .asciiz "Welcome to Airplane Rush! Press SPACE to begin.\n"

.text

main:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $v0, 4
	la $a0, welcome_text
	syscall
	
	jal draw_sky

	li $a0, PLANE_X_COORD
	li $a2, PLANE_MID_COORD
	jal draw_plane	
	
	li $t9, PLANE_MID_COORD
	jal listen_game_start
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	li $v0, 10
	syscall

# Parameters: $a0: x_coordinate, $a1: width, $a2: y_coordinate, $a3: height
draw_object:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)

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
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

draw_sky:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, CYAN
	li $a0, 0
	li $a1, 512
	li $a2, 0
	li $a3, 256
		
	jal draw_object

	lw $ra, 0($sp)
	addiu, $sp, $sp, 4

	jr $ra

# Parameters: $a0 = Plane's x axis, $a2 = Plane's y axis
draw_plane:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, GREEN
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

listen_game_start:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	pool_loop:
		lw $t0, 0xffff0000
		andi $t0, $t0, 0x0001
		beq $t0, $zero, pool_loop
	
	lw $t1, 0xffff0004
	
	beq $t1, SPC_BUTTON, game_begin
	j pool_loop

	lw $ra, 0($sp)
	addiu, $sp, $sp, 4

	jr $ra

listen_button:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	lw $t0, 0xffff0000
	andi $t0, $t0, 0x0001	

	bne $t0, 1, end_listen
	
	lw $t1, 0xffff0004
	
	beq $t1, W_BUTTON, w_button_pressed
	beq $t1, S_BUTTON, s_button_pressed
	
	w_button_pressed:
		ble $t9, PLANE_UP_COORD, end_listen

		addiu $t9, $t9, -80
	
		beq $t9, PLANE_MID_COORD, draw_mid_w
		beq $t9, PLANE_UP_COORD, draw_upper_w
	
		draw_mid_w: 
			li $a0, PLANE_X_COORD
			li $a2, PLANE_DOWN_COORD
			jal plane_relocate
			
			li $a0, PLANE_X_COORD
			li $a2, PLANE_MID_COORD
			jal draw_plane
			
			j end_listen
		
		draw_upper_w:
			li $a0, PLANE_X_COORD
			li $a2, PLANE_MID_COORD
			jal plane_relocate
	
			li $a0, PLANE_X_COORD	
			li $a2, PLANE_UP_COORD
			jal draw_plane
		
			j end_listen

	s_button_pressed:
		bge $t9, PLANE_DOWN_COORD, end_listen

		addiu $t9, $t9, 80
		
		beq $t9, PLANE_MID_COORD, draw_mid_s
		
		beq $t9, PLANE_DOWN_COORD, draw_lower_s
		
		draw_mid_s:
			li $a0, PLANE_X_COORD
			li $a2, PLANE_UP_COORD
			jal plane_relocate
			
			li $a0, PLANE_X_COORD
			li $a2, PLANE_MID_COORD
			jal draw_plane
			
			j end_listen
		
		draw_lower_s:
			li $a0, PLANE_X_COORD
			li $a2, PLANE_MID_COORD
			jal plane_relocate
			
			li $a0, PLANE_X_COORD
			li $a2, PLANE_DOWN_COORD
			jal draw_plane
			
			j end_listen
		
	end_listen:
		lw $ra, 0($sp)
		addiu, $sp, $sp, 4

		jr $ra

game_begin:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)	
	
	li $t6, 2
	li $s6, 1
	
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
	
	jal plane_flies_to_castle
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

# Parameters: $a0 = Plane's x axis, $a2 = Plane's y axis
plane_relocate:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $s0, $zero, CYAN
	li $a1, PLANE_WIDTH
	li $a3, PLANE_HEIGHT
	
	jal draw_object
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

# Parameters: $a0 = Bird's x axis, $a2 = Bird's y axis
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

# Parameters: $a0 = Health Kit's x axis, $a2 = Health Kit's y axis
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

check_health:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	beq $t5, 9, object_touches_plane
	j check_health_return
	
	object_touches_plane:
		
		subi $s4, $s4, 10
		subi $s5, $s5, 10
		
		beq $t9, $s4, bird_hit_plane
		beq $t9, $s5, bird_hit_plane
		
		addi $s4, $s4, 10
		addi $s5, $s5, 10
		
		beq $s6, 3, health_kit_touches_plane
		j check_health_return
		
	health_kit_touches_plane:
		li $s1, HEALTH_KIT_DOWN_COORD
		subi $s7, $s1, 10
	
		beq $t9, $s7, health_kit_taken
		
		j check_health_return
			
	bird_hit_plane:
		subi $t6, $t6, 1
		
		print_health
		
		
		addi $s4, $s4, 10
		addi $s5, $s5, 10
		
		j is_game_ended
	
	health_kit_taken:
		beq $t6, 2, is_game_ended
	
		addi $t6, $t6, 1
		
		print_health
		
	is_game_ended:
		beqz $t6, end_game
		j check_health_return
	
	end_game:
		li $v0, 10
		syscall
	
	check_health_return:
		lw $ra, 0($sp)
		addiu, $sp, $sp, 4
		
		jr $ra

# Parameters: $s4 = Bird 1's y axis, $s5 = Bird 2's y axis
bird_wave:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $t7, BIRD_X_COORD
	li $t8, HEALTH_KIT_X_COORD
	
	li $s3, 13 # Bird movement limit
	move $t5, $zero # Bird movement iteration
	
	move_loop:
		
		jal listen_button
		
		# Draw Bird 1
		move $a2, $s4	
		move $a0, $t7
				
		jal draw_bird
		
		sleep_10ms
		
		# Draw Bird 2
		move $a2, $s5		
		move $a0, $t7
				
		jal draw_bird
		
		# Relocate Bird 1
		move $a2, $s4		
		move $a0, $t7
		
		jal bird_relocate
		
		sleep_10ms

		# Relocate Bird 2
		move $a2, $s5	
		move $a0, $t7
		
		jal bird_relocate

		subi $t7, $t7, 30
		
		sleep_100ms
		
		# Redraw Bird 1
		move $a2, $s4
		move $a0, $t7
		
		jal draw_bird
		
		sleep_10ms
		
		# Redraw Bird 2
		move $a2, $s5
		move $a0, $t7
		
		jal draw_bird
				
		beq $s6, 3, draw_hkit
		j continue_loop
	
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
		
		continue_loop:
			subi $s3, $s3, 1
			addi $t5, $t5, 1
			
			jal check_health
			
			bnez $s3, move_loop
		
	addi $s6, $s6, 1
	
	# Bird 1 Out
	move $a2, $s4		
	move $a0, $t7	
	jal bird_relocate
	
	# Bird 2 Out
	move $a2, $s5	
	move $a0, $t7
	jal bird_relocate
	
	# Health Kit Out
	move $a0, $t8
	li $a2, HEALTH_KIT_DOWN_COORD
	jal health_kit_relocate
	
	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra

plane_flies_to_castle:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	li $s1, 7
	li $t0, PLANE_X_COORD
	
	move $a0, $t0
	move $a2, $t9
	jal plane_relocate

	plane_move_loop:
	
		move $a0, $t0
		move $a2, $t9
		jal draw_plane
		
		move $a0, $t0
		move $a2, $t9
		jal plane_relocate

		addi $t0, $t0, 51
		
		sleep_100ms
		
		move $a0, $t0
		move $a2, $t9
		jal draw_plane
	
		subi $s1, $s1, 1
	
		bnez $s1, plane_move_loop

	lw $ra, 0($sp)
	addiu, $sp, $sp, 4
	
	jr $ra