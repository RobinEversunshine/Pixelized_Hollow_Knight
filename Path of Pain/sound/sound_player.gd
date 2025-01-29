extends Node

const white_palace = preload("res://assets/sfx/songs/S30 White Palace.wav")
const path_of_pain = preload("res://assets/sfx/songs/S59-55 Final Stage 1.wav")
const path_of_pain2 = preload("res://assets/sfx/songs/S59-55 Final Stage 2.wav")
const path_of_pain3 = preload("res://assets/sfx/songs/S59-55 Final Stage 3.wav")
const path_of_pain4 = preload("res://assets/sfx/songs/S59-55 Final Stage 4.wav")
const path_of_pain5 = preload("res://assets/sfx/songs/S59-55 Final Stage 5.wav")

const HURT = preload("res://assets/sfx/The Knight/hero_damage.wav")
const DASH = preload("res://assets/sfx/The Knight/hero_dash.wav")
const JUMP = preload("res://assets/sfx/The Knight/hero_jump.wav")
const WALLJUMP = preload("res://assets/sfx/The Knight/hero_mantis_claw.wav")
const DOUBLEJUMP = preload("res://assets/sfx/The Knight/hero_wings.wav")
const RUN = preload("res://assets/sfx/The Knight/hero_run_footsteps_stone.wav")
const LAND = preload("res://assets/sfx/The Knight/hero_land_soft.wav")
const LANDHARD = preload("res://assets/sfx/The Knight/hero_land_hard.wav")
const ATTACK = preload("res://assets/sfx/The Knight/sword_1.wav")
#const RUN = preload()
const SD_air_brake = preload("res://assets/sfx/The Knight/hero_super_dash_air_brake.wav")
const SD_dash_burst = preload("res://assets/sfx/The Knight/hero_super_dash_burst.wav")
const SD_charge = preload("res://assets/sfx/The Knight/hero_super_dash_charge.wav")
const SD_impact = preload("res://assets/sfx/The Knight/hero_super_dash_impact_wall.wav")
const SD_dash_loop = preload("res://assets/sfx/The Knight/hero_super_dash_loop.wav")
const SD_dash_ready = preload("res://assets/sfx/The Knight/hero_super_dash_ready.wav")

const SWITCH = preload("res://assets/sfx/switch_gate_switch.wav")

const ui_button_confirm = preload("res://assets/sfx/ui/ui_button_confirm.wav")
const ui_save = preload("res://assets/sfx/ui/ui_save.wav")


@onready var audio_players = $AudioPlayers
@onready var song_players = $SongPlayers
@onready var song_stream = $SongPlayer


func play_sound(sound):
#	audio_stream.stream = sound
#	audio_stream.play()
	for audio_stream in audio_players.get_children():
		if not audio_stream.playing:
			audio_stream.stream = sound
			audio_stream.play()
			break

func stop(sound):
	for audio_stream in audio_players.get_children():
		if audio_stream.stream == sound:
			audio_stream.stop()
			break

func stop_all_sound():
	for audio_stream in audio_players.get_children():
		if audio_stream.playing:
			audio_stream.stop()

func play_music(music):
	#for song_stream in song_players.get_children():
	if song_stream.stream != music:
		#break
	#else:
		create_tween().tween_property(song_stream, "volume_db", -20, 1)
		await get_tree().create_timer(1).timeout
		song_stream.stream = music
		song_stream.play()
		create_tween().tween_property(song_stream, "volume_db", 0, 1)
		#break

func add_music(music):
	for song_stream in song_players.get_children():
		if song_stream.stream == music:
			break
		if !song_stream.playing:
			song_stream.stream = music
			song_stream.play()
			song_stream.volume_db = -80
			break


func stop_music():
	for song_stream in song_players.get_children():
		create_tween().tween_property(song_stream, "volume_db", -20, 1)

	await get_tree().create_timer(1).timeout
	for song_stream in song_players.get_children():
		song_stream.stream = null
	

func set_volume(music):
	for song_stream in song_players.get_children():
		if song_stream.stream == music:
			if song_stream.volume_db > 70:
				break
			else:
				create_tween().tween_property(song_stream, "volume_db", 0, 1)
				break
