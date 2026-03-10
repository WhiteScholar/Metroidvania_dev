class_name PlayerStateDash extends PlayerState

const DASH_AUDIO = preload("uid://d3qwceusqkny8")

@export var duration : float = 0.25
@export var speed : float = 300.0
@export var effect_delay : float = 0.05

var dir : float = 1.0
var time : float = 0.0
var effect_time : float = 0.0

@onready var damage_area = %DamageArea


# What happens when this state is initiated?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	#play animation
	player.animation_player.play( "dash" )
	
	time = duration
	effect_time = 0.0
	get_direction()
	
	# set invulnerable
	damage_area.make_invulnerable( duration )
	Audio.play_spatial_sound( DASH_AUDIO, player.global_position )
	
	player.gravity_multiplier = 0.0
	player.velocity.y = 0
	
	player.dash_count += 1
	player.sprite.tween_color()
	pass


# What happens when we exit this state?
func exit() -> void:
	player.gravity_multiplier = 1.0
	if player.is_on_floor():
		player.dash_count = 0
	pass


# what happens when an input is pressed?
func handle_input( _event : InputEvent ) -> PlayerState:
	# Handle Input
	if _event.is_action_pressed( "attack" ):
		return attack
	if _event.is_action_pressed( "jump" ) and player.is_on_floor() == true:
		return jump
	return next_state


# What Happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	time -= _delta
	if time <= 0:
		if player.is_on_floor():
			return idle
		else:
			return fall
	
	effect_time -= _delta
	if effect_time < 0:
		effect_time = effect_delay
		player.sprite.ghost()
	
#	if player.direction.x != 0:
#		return run
	elif player.direction.y > 0.5:
		return crouch 
	return next_state


# What Happens each process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = ( speed * ( time / duration ) + speed ) * dir
	return next_state


func get_direction() -> void:
	dir = 1.0
	if player.sprite.flip_h == true:
		dir= -1.0
	pass
