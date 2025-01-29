extends State

class_name AirState

@export var double_jump_velocity : float = -250.0
@export var jump_velocity_min : float = -100.0


@export var ground_state : State
@export var wall_state : State
@export var dash_state : State
@export var attack_state : State
@export var shape_cast : ShapeCast2D

@export var jump_double_animation : String = "double_jump"

@onready var effects = $"../../Effects/EffectsPlayer"

var has_double_jumped : bool = false
var has_dashed : bool = false

func state_process(delta):
	if character.is_on_floor():
		next_state = ground_state
	elif shape_cast.is_colliding() and character.velocity.y > jump_velocity_min:
		var collision_shape = shape_cast.get_collider(0).get_child(0)
		if collision_shape != null and collision_shape.one_way_collision == false:
			next_state = wall_state
		elif collision_shape == null:
			next_state = wall_state


func state_input(event : InputEvent):
	#small jump
	if event.is_action_released("jump") and character.velocity.y < jump_velocity_min:
		character.velocity.y = jump_velocity_min
		
	if event.is_action_pressed("jump") and not has_double_jumped:
		double_jump()
#		await get_tree().create_timer(0.4).timeout
		
#		if not shape_cast.is_colliding():
#			playback.travel("fall")
		
	elif event.is_action_pressed("dash") and not has_dashed:
		has_dashed = true
		next_state = dash_state
		
	elif event.is_action_pressed("attack"):
		next_state = attack_state



func on_exit():
	if next_state == ground_state or next_state == wall_state:
		has_double_jumped = false
		has_dashed = false


func double_jump():
	character.velocity.y = double_jump_velocity
	playback.travel(jump_double_animation)
	effects.play("double_jump")
	SoundPlayer.play_sound(SoundPlayer.DOUBLEJUMP)
	has_double_jumped = true



func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "jump" or anim_name == "double_jump":
		playback.travel("fall")
		character.update_height()
