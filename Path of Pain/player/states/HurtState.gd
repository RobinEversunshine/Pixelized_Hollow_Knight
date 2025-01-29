extends State

class_name HurtState

var hurt_dir : int

@export var air_state : State
@export var ground_state : State

@onready var effects = $"../../Effects/EffectsPlayer"
@onready var audio = $"../../SFX/AudioStreamPlayer"


func on_enter():
	
	if not character.is_respawn:
		playback.travel("hurt")
		SoundPlayer.play_sound(SoundPlayer.HURT)
		character.camera.shake = 10
		character.velocity = Vector2(0, 0)
		has_gravity = false
		effects.play("hurt")
	
		await get_tree().create_timer(0.2).timeout
		
		if character.hurt_pos.x - character.position.x < 0:
			hurt_dir = 1
		else:
			hurt_dir = -1
		
		character.velocity.x = hurt_dir * 450
		character.velocity.y = -200
		has_gravity = true
		
		await get_tree().create_timer(0.3).timeout
		playback.travel("fall")
		effects.play("RESET")
		next_state = air_state
		
	else:
		playback.travel("on_wall")
		SoundPlayer.play_sound(SoundPlayer.HURT)
		character.camera.shake = 10
		character.velocity = Vector2(0, 0)
		has_gravity = false
		effects.play("hurt")

		await get_tree().create_timer(0.2).timeout
		
		has_gravity = true
		if character.current_checkpoint != null:
			character.position = character.current_checkpoint.global_position
		
		playback.travel("Move")
		effects.play("RESET")
		next_state = ground_state

		
		
		
		
		
