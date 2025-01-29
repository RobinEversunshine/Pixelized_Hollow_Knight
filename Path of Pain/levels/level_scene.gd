extends Node2D

@onready var wraps = $Wraps

@export var scene_index : int
@export var final_stage_3 : bool = false
@export var music : AudioStream

func _ready():
	if Game.portal_name != null:
		var portal_node = wraps.find_child(Game.portal_name)
		if portal_node != null:
			portal_node.enter_scene()
	
	if scene_index > Game.save_scene:
		Game.save_scene = scene_index
	
	SaveAndLoad.save_game()
	
	SoundPlayer.stop_all_sound()
	await SoundPlayer.play_music(SoundPlayer.path_of_pain)
	#SoundPlayer.add_music(SoundPlayer.path_of_pain2)
	SoundPlayer.add_music(SoundPlayer.path_of_pain2)
	SoundPlayer.add_music(SoundPlayer.path_of_pain3)
	SoundPlayer.add_music(SoundPlayer.path_of_pain4)
	SoundPlayer.add_music(SoundPlayer.path_of_pain5)
	
	if final_stage_3:
		SoundPlayer.set_volume(SoundPlayer.path_of_pain3)
	
	await get_tree().create_timer(36).timeout
	SoundPlayer.set_volume(SoundPlayer.path_of_pain2)
	
	
