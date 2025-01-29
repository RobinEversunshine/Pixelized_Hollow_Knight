extends Area2D

@onready var anim = $"../AnimatedSprite2D"
@onready var audio_stream_player = $"../AudioStreamPlayer"


func _process(delta):
	if anim.animation == "hurt":
		monitoring = false
		monitorable = false
	else:
		monitoring = true
		monitorable = true
	

func _on_animated_sprite_2d_animation_finished():
	anim.play("idle")


func _on_body_entered(body):
	if body.name == "player":
		body.hurt()
		body.hurt_pos = global_position


func hurt():
	anim.play("hurt")
	audio_stream_player.play()
	
