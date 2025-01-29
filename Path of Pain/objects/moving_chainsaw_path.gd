extends Path2D

@export var loop = false
@export var speed = 2.0
@export var speed_scale = 1.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer


func _ready():
	animation.stop()
	if not loop:
		animation.play("move")
		animation.speed_scale = speed_scale
		set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if loop:
		path.progress += speed
