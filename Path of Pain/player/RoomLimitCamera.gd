extends Area2D

@onready var collision_shape = get_node("CollisionShape2D")
var minus_limit : float = 16.0

func _ready():
	collision_shape.shape.extents.y -= minus_limit

func _on_body_entered(body):
	if body.name == "player":
		if "NoneLimit" in self.name:
			body.camera.restore_limits()
		else:
			body.camera.update_limits_by_room(self)
