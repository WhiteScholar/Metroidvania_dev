# Visual Effects Engine
extends Node

const DUST_EFFECT = preload("uid://bar18n5hxftbr")
const HIT_PARTICLES = preload("uid://bld1dd0b5vf2d")

signal camera_shook( strength : float )



# Create Dust Effects
func _create_dust_effect( pos : Vector2 ) -> DustEffect:
	# Create new dust instance
	var dust : DustEffect = DUST_EFFECT.instantiate()
	# Add to the scene tree
	add_child( dust )
	# position node
	dust.global_position = pos
	# return the node
	return dust

# Create Jump Dust
func jump_dust(  pos : Vector2 ) -> void:
	var dust: DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.JUMP )
	print( "jump dust effect" )
	pass

# Create Land Dust
func land_dust( pos : Vector2 ) -> void:
	var dust: DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.LAND )
	print( "land dust effect" )
	pass

# Create Hit Dust
func hit_dust( pos : Vector2 ) -> void:
	var dust: DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.HIT )
	print( "hit dust effect" )
	pass


func hit_particles( pos : Vector2, dir : Vector2, settings : HitParticleSettings ) -> void:
	var p : HitParticles = HIT_PARTICLES.instantiate()
	add_child( p )
	p.global_position = pos
	p.start( dir, settings )
	pass


func camera_shake( strength : float = 1.0 ) -> void:
	camera_shook.emit( strength )
	pass
