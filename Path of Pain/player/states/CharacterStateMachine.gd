extends Node

class_name CharacterStateMachine

var states : Array[State]

@export var Character : CharacterBody2D
@export var animation_tree : AnimationTree
@export var current_state : State



func _ready():
	for child in get_children():
		if child is State:
			states.append(child)
			child.character = Character
			child.playback = animation_tree["parameters/playback"]
		else:
			push_warning("Child " + child.name + " is not a State for CharacterStateMachine")

func _physics_process(delta):
	if current_state.next_state != null:
		switch_states(current_state.next_state)
		
	current_state.state_process(delta)


func check_if_can_move():
	return current_state.can_move

func switch_states(newstate : State):
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
		
	#current_state.last_state = current_state
	current_state = newstate
	
	current_state.on_enter()

func _input(event):
	current_state.state_input(event)

