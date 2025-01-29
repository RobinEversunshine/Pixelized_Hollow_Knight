extends Area2D

class_name Checkpoint



func _on_body_entered(body):
	if body.name == "player":
		body.current_checkpoint = self
