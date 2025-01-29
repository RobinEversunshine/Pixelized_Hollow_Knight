extends State

class_name WallState

@export var wall_jump_velocity : Vector2 = Vector2(400.0, -250.0)
@export var leave_ground_limit : float = 0.05
const wall_friction : float = 7
var wall_normal : Vector2

@export var ground_state : State
@export var air_state : State
@export var dash_state : State
@export var super_dash_state : State
@export var shape_cast : ShapeCast2D

@export var jump_animation : String = "jump"
@export var wall_animation : String = "on_wall"
@export var fall_animation : String = "fall"

@onready var effects = $"../../Effects/EffectsPlayer"

func state_process(delta):
	wall_normal = character.get_wall_normal()
	character.dir = wall_normal.x
	
	character.velocity.y = move_toward(character.velocity.y, 0, wall_friction)
	
	if character.is_on_floor():
		next_state = ground_state
		
	elif not shape_cast.is_colliding() and not character.is_wall_jump:
		playback.travel(fall_animation)
		
	if character.leave_ground > leave_ground_limit:
		next_state = air_state



func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		wall_jump()
	elif event.is_action_pressed("dash"):
		next_state = dash_state
	
	if event.is_action_pressed("super_dash"):
		playback.travel("sd_charging_wall")
		effects.play("sd_charging_wall")
		next_state = super_dash_state



func on_enter():
	character.velocity.y = 0
	playback.travel(wall_animation)
	air_state.has_dashed = false
	air_state.has_double_jumped = false

func on_exit():
	character.update_height()


func wall_jump():
	character.is_wall_jump = true
	
	character.velocity.y = wall_jump_velocity.y
	character.velocity.x = character.dir * wall_jump_velocity.x
	playback.travel(jump_animation)
	SoundPlayer.play_sound(SoundPlayer.WALLJUMP)
	
	await get_tree().create_timer(0.1).timeout
	character.is_wall_jump = false
	next_state = air_state
	
	
	

