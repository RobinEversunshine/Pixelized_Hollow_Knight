extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var color_rect = $ColorRect

func _ready():
	animation_player.play("RESET")


func fade_in():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	
func fade_out():
	animation_player.play("fade_out")
	await animation_player.animation_finished

func black():
	animation_player.play("black")
	
