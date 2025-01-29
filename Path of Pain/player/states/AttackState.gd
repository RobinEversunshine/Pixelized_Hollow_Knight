extends State

class_name AttackState

@export var attack_jump_velocity : float = -150.0
@export var attack_wait : float  = 0.15
var attack_wait_time : float  = 0

@export var ground_state : State
@export var air_state : State
@export var shape_cast2 : ShapeCast2D
@export var down_hitbox : Area2D
@export var hitbox : Area2D

@onready var effects = $"../../Effects/EffectsPlayer"


func state_process(delta):
	attack_wait_time += delta
	if attack_wait_time > attack_wait:
		change_state()


func on_enter():
	if Input.is_action_pressed("down") and not shape_cast2.is_colliding():
		down_hitbox.monitoring = true

		playback.travel("down_attack")
		effects.play("down_attack")
		SoundPlayer.play_sound(SoundPlayer.ATTACK)

	else:
		hitbox.monitoring = true
		playback.travel("attack")
		effects.play("attack")
		SoundPlayer.play_sound(SoundPlayer.ATTACK)




func on_exit():
	down_hitbox.monitoring = false
	hitbox.monitoring = false
	effects.play("RESET")
	attack_wait_time = 0

func change_state():
	if character.is_on_floor():
		next_state = ground_state
		playback.travel("move")
	else:
		next_state = air_state
		playback.travel("fall")



func down_hit_jump():
	if down_hitbox.monitoring:
		character.velocity.y = attack_jump_velocity


func _on_down_attack_area_entered(area):
	for child in area.get_children():
		if child.name == "can_hit_jump":
			down_hit_jump()
			character.camera.shake = 3
			character.update_height()
			air_state.has_double_jumped = false
			air_state.has_dashed = false
			area.hurt()



func _on_attack_area_entered(area):
	for child in area.get_children():
		if child.name == "can_hit_jump":
			character.camera.shake = 3
			area.hurt()
