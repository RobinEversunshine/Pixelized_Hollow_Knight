extends Node

const save_path = "res://savegame.bin"

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var data: Dictionary = {
		"hurt_times": Game.hurt_times,
		"save_scene": Game.save_scene,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func load_game():
	var file = FileAccess.open(save_path, FileAccess.READ)
	if FileAccess.file_exists(save_path):
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Game.hurt_times = current_line["hurt_times"]
				Game.save_scene = current_line["save_scene"]
