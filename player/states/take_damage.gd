class_name PlayerStateTakeDamage extends PlayerState

@export var move_speed : float = 100
@export var invulnerable_duration : float = 0.5
var time : float = 0
var dir : float = 1.0
@onready var damage_area: DamageArea = %DamageArea
@onready var hurt_audio: AudioStreamPlayer2D = %HurtAudio


# What happens when this state is initiated?
func init() -> void:
	damage_area.damage_taken.connect( _on_damage_taken )
	pass


# What happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "take_damage" )
	# set timer
	time = player.animation_player.current_animation_length
	# Make invulnerable
	damage_area.make_invulnerable( invulnerable_duration )
	# play audio
	hurt_audio.play()
	#VisualEffects.camera_shake(1)
	pass


# What happens when we exit this state?
func exit() -> void:
	pass


# what happens when an input is pressed?
func handle_input( _event : InputEvent ) -> PlayerState:
	# Handle Input
	return next_state


# What Happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	time -= _delta
	if time <= 0:
		return idle
	return next_state


# What Happens each process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = move_speed * dir
	return null



func _on_damage_taken( attack_area : AttackArea ) -> void:
	player.change_state( self )
	VisualEffects.camera_shake((attack_area.damage / player.max_hp) * 20)
	print( "Screen Shake Velocity: ", (attack_area.damage / player.max_hp) * 20)
	player.velocity = -player.velocity
	if attack_area.global_position.x < player.global_position.x:
		dir = 1.0
	else:
		dir = -1.0
	pass
