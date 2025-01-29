extends Node2D

@onready var settings = $CanvasLayer/Settings
@onready var menu = $CanvasLayer/Menu
@onready var camera = $Camera2D
@onready var continue_ = $CanvasLayer/Menu/Panel/VBoxContainer/continue_
@onready var start_game = $CanvasLayer/Menu/Panel/VBoxContainer/start_game
@onready var title = $CanvasLayer/Menu/Title

#var file = FileAccess.open(SaveAndLoad.save_path, FileAccess.READ)
	

func _ready():
	if FileAccess.file_exists(SaveAndLoad.save_path):
		continue_.disabled = false
		start_game.text = "New Game"
	
	LevelTransition.black()
	await get_tree().create_timer(1).timeout
	LevelTransition.fade_out()
	SoundPlayer.play_music(SoundPlayer.white_palace)

func _process(delta):
	title.scale = Game.zoom
	title.position = get_window().size / 2

func _on_quit_game_pressed():
	SoundPlayer.play_sound(SoundPlayer.ui_save)
	LevelTransition.fade_in()
	await LevelTransition.animation_player.animation_finished
	get_tree().quit()


func _on_start_game_pressed():
#	SoundPlayer.stop_music()
	SoundPlayer.play_sound(SoundPlayer.ui_button_confirm)
	await LevelTransition.fade_in()
	camera.enabled = false
	get_tree().change_scene_to_file("res://levels/scene_1.tscn")
	LevelTransition.fade_out()



func _on_options_pressed():
	settings.visible = true
	menu.hide()


func _on_continue_pressed():
	SaveAndLoad.load_game()
#	SoundPlayer.stop_music()
	SoundPlayer.play_sound(SoundPlayer.ui_button_confirm)
	await LevelTransition.fade_in()
	camera.enabled = false
	var load_scene : String = "res://levels/scene_"+str(Game.save_scene)+".tscn"
	
	get_tree().change_scene_to_file(load_scene)
	LevelTransition.fade_out()
