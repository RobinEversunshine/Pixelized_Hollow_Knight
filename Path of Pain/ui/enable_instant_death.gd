extends CheckButton



func _ready():
	button_pressed = Game.instant_death





func _on_toggled(button_pressed):
	Game.instant_death = button_pressed
