class_name PlayerStateAttack extends PlayerState


@export var AUDIO_ATTACK: AudioStream = preload("uid://bry57pg6prusi")
@export var combo_time_window : float = 0.25
@export var move_speed : float = 150
var timer : float = 0.0
var combo : int = 0

@onready var attack_sprite_2d: Sprite2D = %AttackSprite2D



# What happens when this state is initiated?
func init() -> void:
	attack_sprite_2d.visible = false
	pass


# What happens when we enter this state?
func enter() -> void:
	do_attack()
	player.animation_player.animation_finished.connect( _on_animation_finished )
	pass


# What happens when we exit this state?
func exit() -> void:
	player.animation_player.animation_finished.disconnect( _on_animation_finished )
	attack_sprite_2d.visible = false
	next_state = null
	combo = 0
	pass


# what happens when an input is pressed?
func handle_input( _event : InputEvent ) -> PlayerState:
	 #Handle Input
	if _event.is_action_pressed( "attack" ):
		timer = combo_time_window
	if _event.is_action_released( "jump" ) and player.velocity.y < 0:
		player.velocity.y *= 0.5
	if _event.is_action_pressed( "jump" ):
		if player.is_on_floor():
			return jump
	return next_state


# What Happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if timer > 0:
		timer -= _delta
		if timer < 0:
			timer = 0
	return next_state


# What Happens each process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * move_speed
#	player.velocity.x = 0
#	if player.is_on_floor() == false:
#		return fall
	return null


func do_attack() -> void:
	var anim_name : String = "attack"
	if combo > 0:
		anim_name = "attack_2"
	player.attack_area.activate(0.2)
	player.animation_player.play( anim_name )
	Audio.play_spatial_sound( AUDIO_ATTACK, player.global_position )
	pass


func _end_attack() -> void:
	if timer > 0:
		combo = wrapi( combo + 1, 0, 2 )
		do_attack()
	else:
		if player.is_on_floor():
			next_state = idle
		else:
			next_state = fall
	pass


func _on_animation_finished( _anim_name : String ) -> void:
	_end_attack()
	pass
