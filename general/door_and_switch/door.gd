@tool
@icon("res://general/icons/door.svg")
class_name Door extends Node2D

const DOOR_CRASH_AUDIO = preload("res://general/door_and_switch/door_crash.wav")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var camera_shake_on_open : float = 0
@export var particle_settings : HitParticleSettings

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for c in get_children():
		if c is Switch:
			c.activated.connect( _on_switch_activated )
			if c.is_open == true:
				_on_switch_is_open()
	pass


func _on_switch_activated() -> void:
	# Audio playback
	Audio.play_spatial_sound( DOOR_CRASH_AUDIO, global_position )
	# Play Animation
	animation_player.play( "open" )
	VisualEffects.hit_particles( Vector2( global_position.x, global_position.y - 96.0 ), Vector2(0,1), particle_settings )
	VisualEffects.hit_particles( Vector2( global_position.x, global_position.y ), Vector2(0,-1), particle_settings )
	VisualEffects.camera_shake( camera_shake_on_open )
	pass


func _on_switch_is_open() -> void:
	animation_player.play( "opened" )
	pass


func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_switch() == false:
		return [ "Requires a child Switch node." ]
	return []


func _check_for_switch() -> bool:
	for c in get_children():
		if c is Switch:
			return true
	return false
