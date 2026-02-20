@icon( "res://general/icons/damage_area.svg" )
class_name DamageArea extends Area2D

signal damage_taken( attack_area )

@export var audio: AudioStream
@export var invulnerable_timer: bool = false
@export var invulnerability_time: float = 1.0


func take_damage( attack_area : AttackArea ) -> void:
	print( attack_area.damage, " Damage! ", attack_area.name )
	damage_taken.emit( attack_area )
	#VisualEffects.hit_dust( global_position )
	if audio:
		Audio.play_spatial_sound( audio, global_position )
	if invulnerable_timer == true:
		make_invulnerable( invulnerability_time )
	pass



func make_invulnerable( duration: float = 1.0 ) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer( duration ).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
	pass
