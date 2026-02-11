@tool
@icon( "res://general/icons/level_bounds.svg" )
class_name LevelBounds extends Node2D

@export_range( 480, 2048, 32, "suffix:px" ) var width : int = 480 : set = _on_width_change
@export_range( 278, 2048, 32, "suffix:px" ) var hight : int = 278 : set = _on_hight_change


func _ready() -> void:
	z_index = 256
	
	if Engine.is_editor_hint():
		return
		
	var _camera : Camera2D = null
		
	while not _camera:
		await get_tree().process_frame
		_camera = get_viewport().get_camera_2d()
	
	_camera.limit_left = int( global_position.x )
	_camera.limit_top = int( global_position.y )
	_camera.limit_right = int( global_position.x ) + width
	_camera.limit_bottom = int( global_position.y ) + hight

	pass
	
	
func _draw() -> void:
	if Engine.is_editor_hint():
		var r : Rect2 = Rect2( Vector2.ZERO, Vector2( width, hight ) )
		draw_rect( r, Color( 0.0, 0.45, 1.0, 0.6 ), false, 3 )
		draw_rect( r, Color( 0.0, 0.75, 1.0 ), false, 1 )
	pass
	
	
func _on_width_change(new_width) -> void:
	width = new_width
	queue_redraw()
	pass


func _on_hight_change(new_hight) -> void:
	hight = new_hight
	queue_redraw()
	pass
