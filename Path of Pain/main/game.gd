extends Node

var hurt_times : int = 0
var save_scene : int = 0

var portal_name : String
var can_wrap : bool = true
var instant_death : bool = true
var zoom : Vector2 = Vector2(3, 3)

signal toggle_game_paused(is_paused : bool)

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)


func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel") and get_tree().get_current_scene().get_name() != "StartScene":
		game_paused = !game_paused

func _process(delta):
	if Game.can_wrap == false:
		await get_tree().create_timer(1).timeout
		Game.can_wrap = true
	
func update_zoom():
	#print("zoomchanged")
	var window_size = get_window().size
	zoom.x = window_size.x / 384.0
	zoom.y = window_size.y / 216.0
	if zoom.x > zoom.y:
		zoom.y = zoom.x
	else:
		zoom.x = zoom.y


func _ready():
	get_window().size_changed.connect(update_zoom)


