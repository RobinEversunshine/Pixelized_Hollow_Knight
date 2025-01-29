extends State

class_name DashState

@export var dash_speed : float  = 650.0
@export var dash_wait : float  = 0.15
var dash_wait_time : float  = 0

@export var ground_state : State
@export var air_state : State
@export var wall_state : State

@export var dash_animation : String = "dash"

@onready var effects = $"../../Effects/EffectsPlayer"

func state_process(delta):
	character.velocity.y = 0
	dash_wait_time += delta
	if dash_wait_time > dash_wait:
		character.update_height()
		change_state()
		

func on_enter():
	character.velocity.x = character.dir * dash_speed
	playback.travel(dash_animation)
	effects.play("dash")
	SoundPlayer.play_sound(SoundPlayer.DASH)


func on_exit():
	dash_wait_time = 0

func change_state():
	if character.is_on_floor():
		next_state = ground_state
		playback.travel("move")
	elif not character.is_on_wall():
		next_state = air_state
		playback.travel("fall")
	elif character.is_on_wall():
		effects.play("RESET")
		next_state = wall_state
