extends Control

@onready var game_manager = $"../.."
@onready var settings = $"../Settings"


func _ready():
	hide()
	game_manager.connect("toggle_game_paused", game_manager_toggole_paused)


#func _input(event : InputEvent):
#	if event.is_action_pressed("ui_cancel"):
#		game_manager.game_paused = !game_manager.game_paused


func game_manager_toggole_paused(is_paused : bool):
	if is_paused:
		show()
		SoundPlayer.song_stream.volume_db = -10
		for song_stream in SoundPlayer.song_players.get_children():
			if song_stream.volume_db > -15:
				song_stream.volume_db = -10
	else:
		hide()
		SoundPlayer.song_stream.volume_db = 0
		for song_stream in SoundPlayer.song_players.get_children():
			if song_stream.volume_db > -15:
				song_stream.volume_db = 0




func _on_resume_pressed():
	game_manager.game_paused = false


func _on_exit_pressed():
	SoundPlayer.play_sound(SoundPlayer.ui_save)
	LevelTransition.fade_in()
	await LevelTransition.animation_player.animation_finished
	get_tree().quit()


func _on_quit_to_menu_pressed():
	SoundPlayer.stop_music()
	SoundPlayer.play_sound(SoundPlayer.ui_save)
	await LevelTransition.fade_in()
	game_manager.game_paused = false
	get_tree().change_scene_to_file("res://levels/start_scene.tscn")
	LevelTransition.fade_out()


func _on_options_pressed():
	settings.visible = true
	hide()
