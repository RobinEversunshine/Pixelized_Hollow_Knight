extends Area2D


@onready var player = $"../../player"


@export var scene_to_load : String

@export var player_position : Vector2 = self.position
@export var player_direction : int = -1

@export var limit_left = -10000000
@export var limit_right = 10000000
@export var limit_top = -10000000
@export var limit_bottom = 10000000


func _on_body_entered(body):
	if body.name == "player" and Game.can_wrap:
		await LevelTransition.fade_in()
		if scene_to_load != null:
			Game.portal_name = name
			var new_scene = scene_to_load
			get_tree().change_scene_to_file(new_scene)
		Game.can_wrap = false
		


func enter_scene():
	player.position = player_position
	player.dir = player_direction
	player.camera.limit_left = limit_left
	player.camera.limit_right = limit_right
	player.camera.limit_top = limit_top
	player.camera.limit_bottom = limit_bottom
	await get_tree().create_timer(0.5).timeout
	LevelTransition.fade_out()
