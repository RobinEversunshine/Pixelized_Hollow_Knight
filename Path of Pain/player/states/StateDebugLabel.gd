extends Label

@export var state_machine : CharacterStateMachine
@onready var charcater = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "State : " + state_machine.current_state.name
	# + '''
	#''' + "LastState : " + str(state_machine.current_state.last_state)
	#print(state_machine.current_state.can_move)
