class_name PlayerStateAttackTEST extends PlayerState
@onready var attack_area = %AttackArea




# What happens when this state is initiated?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	attack_area.activate(0.2)
	player.animation_player.play("attack_TEST")
	await get_tree().create_timer(0.2).timeout
	pass


# What happens when we exit this state?
func exit() -> void:
	
	pass


# what happens when an input is pressed?
func handle_input( _event : InputEvent ) -> PlayerState:
	
	return next_state


# What Happens each process tick in this state?
func process( _delta: float ) -> PlayerState:

	return next_state


# What Happens each process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	
	return next_state
