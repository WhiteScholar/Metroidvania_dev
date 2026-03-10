class_name PlayerStateDeath extends PlayerState

const DEATH_AUDIO = preload("uid://bvfywyjuf6lut")


# What happens when this state is initiated?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.damage_area.queue_free()
	player.animation_player.play( "death" )
	Audio.play_spatial_sound( DEATH_AUDIO, player.global_position )
	Audio.play_music( null )
	await player.animation_player.animation_finished
	PlayerHud.show_game_over()
	pass


# What happens when we exit this state?
func exit() -> void:
	pass


# what happens when an input is pressed?
func handle_input( _event : InputEvent ) -> PlayerState:
	
	return null


# What Happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	
	return null


# What Happens each process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = 0
	return null
	
