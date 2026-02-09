class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 450.0



# What happens when this state is initiated?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	# Play Animation
	player.add_debug_indicator( Color.LIME_GREEN )
	player.velocity.y = -jump_velocity
	pass


# What happens when we exit this state?
func exit() -> void:
	player.add_debug_indicator( Color.YELLOW )
	pass


# what happens when an input is pressed?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_released( "jump" ):
		player.velocity.y *= 0.5
		pass
	return next_state


# What Happens each process tick in this state?
func process( _delta: float ) -> PlayerState:

	return next_state


# What Happens each process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.move_speed
	
	return next_state
