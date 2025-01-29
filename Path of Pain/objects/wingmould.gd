extends CharacterBody2D


@export var filp_sprite : bool = false

@onready var anim = $AnimatedSprite2D



#@onready var hitbox = $Area2D
#
## Called when the node enters the scene tree for the first time.
func _ready():
	anim.flip_h = filp_sprite
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if anim.animation == "hurt":
#		hitbox.monitoring = false
#		hitbox.monitorable = false
#	else:
#		hitbox.monitoring = true
#		hitbox.monitorable = true
#
#
#func _on_area_2d_body_entered(body):
#	if body.name == "player":
#		body.hurt()
#
#
#func _on_animated_sprite_2d_animation_finished():
#	anim.play("idle")
#
#
#
##func _on_area_2d_area_entered(area):
##	if area.name == "DownAttack" and area.monitoring:
##		hurt()
#
#
#func hurt():
#	anim.play("hurt")
#
