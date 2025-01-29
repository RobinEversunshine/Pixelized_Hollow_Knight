extends Area2D


@onready var gate = $"../gate"
@onready var animated_sprite_2d = $AnimatedSprite2D

func _process(delta):
	if gate == null:
		monitorable = false

func hurt():
	if gate != null:
		#monitorable = false
		gate.queue_free()
		animated_sprite_2d.play("hurt")
		SoundPlayer.play_sound(SoundPlayer.SWITCH)
		
