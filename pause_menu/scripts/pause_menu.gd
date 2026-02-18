class_name PauseMenu extends CanvasLayer

#region /// On ready variables
@onready var pause_screen: Control = %PauseScreen
@onready var system: Control = %System
@onready var system_menu_button: Button = %SystemMenuButton
@onready var back_to_map_button: Button = %BackToMapButton
@onready var back_to_title_button: Button = %BackToTitleButton
@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
@onready var save_config_button: Button = %SaveConfigButton
@onready var config_saved: Control = %ConfigSaved
@onready var confirm_button: Button = %ConfirmButton

#endregion

var player_position : Vector2


func _ready() -> void:
	# grab player
	show_pause_screen()
	system_menu_button.pressed.connect( show_system_menu )
	Audio.setup_button_audio( self )
	setup_system_menu()
	var player : Player = get_tree().get_first_node_in_group("Player")
	if player:
		player_position = player.global_position
	pass




func _unhandled_input( event: InputEvent ) -> void:
	if event.is_action_pressed( "pause" ):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
	if pause_screen.visible == true:
		if event.is_action_pressed("right") or event.is_action_pressed("down"):
			system_menu_button.grab_focus()
	pass

func show_pause_screen() -> void:
	pause_screen.visible = true
	system.visible = false
	config_saved.visible = false

	pass


func show_system_menu() -> void:
	pause_screen.visible = false
	system.visible = true
	back_to_map_button.grab_focus()
	pass


func setup_system_menu() -> void:
	# Setup audio sliders
	master_slider.value = AudioServer.get_bus_volume_linear( 0 )
	music_slider.value = AudioServer.get_bus_volume_linear( 2 )
	sfx_slider.value = AudioServer.get_bus_volume_linear( 3 )
	ui_slider.value = AudioServer.get_bus_volume_linear( 4 )
	# Slider Handling
	master_slider.value_changed.connect( _on_master_slider_changed )
	music_slider.value_changed.connect( _on_music_slider_changed )
	sfx_slider.value_changed.connect( _on_sfx_slider_changed )
	ui_slider.value_changed.connect( _on_ui_slider_changed )
	# Button Handling
	back_to_title_button.pressed.connect( _on_back_to_title_pressed )
	back_to_map_button.pressed.connect( show_pause_screen )
	save_config_button.pressed.connect( _on_save_config_pressed )
	confirm_button.pressed.connect( show_pause_screen )
	pass



func _on_back_to_title_pressed() -> void:
	# free player
	SceneManager.transition_scene( "res://title_screen/title_screen.tscn", "", Vector2.ZERO, "up" )
	get_tree().paused = false
	Messages.back_to_title_screen.emit()
	queue_free()
	pass

func _on_master_slider_changed( v : float ) -> void:
	AudioServer.set_bus_volume_linear( 0, v )
	pass

func _on_music_slider_changed( v : float ) -> void:
	AudioServer.set_bus_volume_linear( 2, v )
	pass

func _on_sfx_slider_changed( v : float ) -> void:
	AudioServer.set_bus_volume_linear( 3, v )
#	Audio.play_spacial_sound( Audio.ui_focus_audio, player_position )
	var apsfx : AudioStreamPlayer = AudioStreamPlayer.new()
	add_child( apsfx )
	apsfx.bus = "SFX"
	apsfx.stream = Audio.ui_focus_audio
	apsfx.finished.connect( apsfx.queue_free )
	apsfx.play()
pass

func _on_ui_slider_changed( v : float ) -> void:
	AudioServer.set_bus_volume_linear( 4, v )
	Audio.ui_focus_change()
	pass

func _on_save_config_pressed() -> void:
	SaveManager.save_configuration()
	pause_screen.visible = false
	system.visible = false
	config_saved.visible = true
	confirm_button.grab_focus()
	pass
