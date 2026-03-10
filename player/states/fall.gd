class_name PlayerStateFall extends PlayerState

@export var fall_gravity_multiplier : float = 1.165
@export var coyote_time : float = 0.125
@export var jump_buffer_time : float = 0.2

var coyote_timer : float = 0
var buffer_timer : float = 0



# What happens when this state is initiated?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "jump" )
	player.gravity_multiplier = fall_gravity_multiplier
	
	#handle jump count
	if player.jump_count == 0:
		player.jump_count = 1
		pass
	var prev : PlayerState = player.previous_state
	if prev == jump or prev == attack or prev == dash:
		coyote_timer = 0
	elif player.previous_state == crouch:
		coyote_timer = 0
		player.jump_count = 1
	else:
		coyote_timer = coyote_time
	pass


# What happens when we exit this state?
func exit() -> void:
	player.gravity_multiplier = 1.0
	buffer_timer = 0
	coyote_timer = 0
	pass


# what happens when an input is pressed?
func handle_input( _event : InputEvent ) -> PlayerState:
	# Handle Input
	if _event.is_action_pressed( "dash" ) and player.can_dash():
		return dash
	if _event.is_action_pressed( "attack" ):
		return attack
	if _event.is_action_pressed( "jump" ):
		if coyote_timer > 0:
			player.jump_count = 0
			return jump
		elif player.jump_count <= 1 and player.double_jump:
			return jump
		else:
			buffer_timer = jump_buffer_time
	return next_state


# What Happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	coyote_timer -= _delta
	buffer_timer -= _delta
	set_jump_frame()
	return next_state


# What Happens each process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		VisualEffects.land_dust( player.global_position )
		Audio.play_spatial_sound(player.land_sfx_audio, player.global_position)
		#player.add_debug_indicator()
		if buffer_timer > 0:
			player.jump_count = 0
			return jump
		return idle
	player.velocity.x = player.direction.x * player.move_speed
	return next_state
	
	
	
	
	
func set_jump_frame() -> void:
	var frame : float = remap( player.velocity.y, 0.0, 400, 0.5, 1.0 )
	player.animation_player.seek( frame, true )
	pass
