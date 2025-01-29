extends State

class_name SuperDashState

var super_dash_charge_time : float = 0
var super_dash_charge_threshold : float  = 0.8
var sd_state : String

@export var super_dash_speed : float  = 650.0

@export var wall_state : State
@export var air_state : State
@export var shape_cast : ShapeCast2D

@onready var effects = $"../../Effects/EffectsPlayer"
@onready var effects2 = $"../../Effects/EffectsPlayer2"

func state_process(delta):
	
	character.velocity.y = 0
	
	if sd_state == "charging":
		
		super_dash_charge_time += delta
		character.camera.shake = 0.5
		
		if super_dash_charge_time >= super_dash_charge_threshold:
			effects2.play("blink")
			
			character.camera.shake = 1
			
		if abs(super_dash_charge_time - super_dash_charge_threshold) <0.01:
			SoundPlayer.play_sound(SoundPlayer.SD_dash_ready)
	
	elif sd_state == "dashing":
		effects.play("super_dash")
		playback.travel("super_dash")
		character.velocity.x = super_dash_speed * character.dir
		character.camera.shake = 0.5
		
		if shape_cast.is_colliding() and character.get_wall_normal().x == -character.dir:
			sd_state = "colliding"
		
	elif sd_state == "colliding":
		effects.play("RESET")
		playback.travel("on_wall")
		SoundPlayer.stop(SoundPlayer.SD_dash_loop)
		SoundPlayer.play_sound(SoundPlayer.SD_impact)
		character.velocity.x = 0
		character.dir = character.get_wall_normal().x
		
		character.camera.shake = 15
		
		sd_state = "falling"

		await get_tree().create_timer(0.5).timeout
		next_state = wall_state
		
	else:
		effects.play("RESET")
		character.velocity.x = move_toward(character.velocity.x, 0, 5)



func state_input(event : InputEvent):
	
	if Input.is_action_just_released("super_dash") and sd_state == "charging":
		if super_dash_charge_time >= super_dash_charge_threshold:
			SoundPlayer.play_sound(SoundPlayer.SD_dash_burst)
			SoundPlayer.play_sound(SoundPlayer.SD_dash_loop)
			sd_state = "dashing"
		else:
			SoundPlayer.stop(SoundPlayer.SD_charge)
			next_state = air_state
	
	if event.is_action_pressed("jump") and sd_state == "dashing":
		sd_state = "falling"
		playback.travel("fall")
		SoundPlayer.stop(SoundPlayer.SD_dash_loop)
		SoundPlayer.play_sound(SoundPlayer.SD_air_brake)
		await get_tree().create_timer(0.2).timeout
		next_state = air_state



func on_enter():
	sd_state = "charging"
	SoundPlayer.play_sound(SoundPlayer.SD_charge)
	super_dash_charge_time = 0

func on_exit():
	effects.play("RESET")
	effects2.play("RESET")
	SoundPlayer.stop(SoundPlayer.SD_dash_loop)


