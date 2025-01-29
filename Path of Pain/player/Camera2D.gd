extends Camera2D


var shake : float = 0
var fade_speed : float = 5.0

@export var camera_limits : Node

func camera_shake(shake_amount : float):
	self.offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * shake_amount

func update_limits():
	var limit_length : Array = []
	
	if camera_limits != null:
		for limit in camera_limits.get_children():
			var length_vector : Vector2 = limit.position - position
			limit_length.append(length_vector.length())

		if limit_length.min() < 300:
			var min_index = limit_length.find(limit_length.min())
			var limit : Marker2D = camera_limits.get_children()[min_index]
			
			if "Free" in limit.name:
				restore_limits()
				
			elif "Room" in limit.name:
				if limit.position.x > position.x:
					limit_right = limit.position.x
					limit_left = -10000000
				elif limit.position.x < position.x:
					limit_left = limit.position.x
					limit_right = 10000000

			elif "Smooth" in limit.name:
				if "Right" in limit.name and limit.position.x > position.x:
					create_tween().tween_property(self, "limit_right", limit.position.x, 1)
				elif "Left" in limit.name and limit.position.x < position.x:
					create_tween().tween_property(self, "limit_left", limit.position.x, 1)
					
				if "Bottom" in limit.name and limit.position.y > position.y:
					create_tween().tween_property(self, "limit_bottom", limit.position.y, 1)
				elif "Top" in limit.name and limit.position.y < position.y:
					create_tween().tween_property(self, "limit_top", limit.position.y, 1)
					
			else:
				if "Right" in limit.name and limit.position.x > position.x:
					limit_right = limit.position.x
				elif "Left" in limit.name and limit.position.x < position.x:
					limit_left = limit.position.x
					
				if "Bottom" in limit.name and limit.position.y > position.y:
					limit_bottom = limit.position.y
				elif "Top" in limit.name and limit.position.y < position.y:
					limit_top = limit.position.y


func update_limits_by_room(area : Area2D):
	var collision_shape = area.get_node("CollisionShape2D")
	var size = collision_shape.shape.extents * 2
	size.y += area.minus_limit * 2
	
	var view_size = get_window().size / zoom.x
	if size.y < view_size.y:
		size.y = view_size.y
	if size.x < view_size.x and not "Left" in area.name and not "Right" in area.name:
		size.x = view_size.x
	
	var top = collision_shape.global_position.y - (size.y / 2)
	var left = collision_shape.global_position.x - (size.x / 2)
	
	var right = collision_shape.global_position.x + (size.x / 2)
	var bottom = top + size.y
	
	if "Left" in area.name:
		right = left + view_size.x
	elif "Right" in area.name:
		left = right - view_size.x
	
	
	create_tween().tween_property(self, "limit_right", right, 1)
	create_tween().tween_property(self, "limit_left", left, 1)
	create_tween().tween_property(self, "limit_top", top, 1)
	create_tween().tween_property(self, "limit_bottom", bottom, 1)


func restore_limits():
	limit_left = -10000000
	limit_right = 10000000
	limit_top = -10000000
	limit_bottom = 10000000


#func update_zoom():
#	#print("zoomchanged")
#	var window_size = get_window().size
#	zoom.x = window_size.x / 384.0
#	zoom.y = window_size.y / 216.0
#	if zoom.x > zoom.y:
#		zoom.y = zoom.x
#	else:
#		zoom.x = zoom.y
#
#
func _process(delta):
#	get_window().size_changed.connect(update_zoom)
	zoom = Game.zoom
	
	if camera_limits != null:
		update_limits()
	if shake != 0:
		shake = lerpf(shake, 0, delta * fade_speed)
		camera_shake(shake)
	
	if Game.can_wrap == false:
		limit_smoothed = false
		await get_tree().create_timer(5).timeout
		limit_smoothed = true
