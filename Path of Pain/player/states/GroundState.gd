extends State

class_name GroundState

@export var jump_velocity : float = -250.0
@export var dash_wait : float = 0.5
@export var leave_ground_limit : float = 0.15

@export var air_state : State
@export var dash_state : State
@export var super_dash_state : State
@export var attack_state : State

@export var jump_animation : String = "jump"
@export var move_animation : String = "Move"
@export var fall_animation : String = "fall"

@onready var effects = $"../../Effects/EffectsPlayer"
@onready var animated_sprite_2d = $"../../AnimatedSprite2D"


var has_dashed : bool = false

func state_process(delta):
	if character.leave_ground > leave_ground_limit:
		playback.travel(fall_animation)
		next_state = air_state



func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		jump()
	
	elif event.is_action_pressed("dash") and not has_dashed:
		has_dashed = true
		next_state = dash_state
		
	elif event.is_action_pressed("super_dash"):
		playback.travel("sd_charging_ground")
		effects.play("sd_charging_ground")
		next_state = super_dash_state
		
	elif event.is_action_pressed("attack"):
		next_state = attack_state


func on_enter():
	playback.travel(move_animation)
	if not character.is_respawn:
		var fall_distance = character.position.y - character.max_height
		
		if fall_distance < 300 and fall_distance > 10:
			SoundPlayer.play_sound(SoundPlayer.LAND)
			character.update_height()
		elif fall_distance > 300:
			character.camera.shake = 3
			SoundPlayer.play_sound(SoundPlayer.LANDHARD)
			can_move = false
			character.update_height()
			await get_tree().create_timer(0.5).timeout
			can_move = true

	

func on_exit():
	if next_state == dash_state:
		await get_tree().create_timer(dash_wait).timeout
		has_dashed = false


func jump():
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel(jump_animation)
	SoundPlayer.play_sound(SoundPlayer.JUMP)



func _on_animated_sprite_2d_animation_changed():
	if animated_sprite_2d.animation == "run":
		SoundPlayer.play_sound(SoundPlayer.RUN)
	else:
		SoundPlayer.stop(SoundPlayer.RUN)
