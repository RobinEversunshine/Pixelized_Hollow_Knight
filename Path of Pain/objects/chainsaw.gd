extends Area2D

@onready var audio_stream_player = $"../AudioStreamPlayer"


func _on_body_entered(body):
	if body.name == "player":
		body.respawn()
		body.hurt_pos = global_position

func hurt():
	audio_stream_player.play()
