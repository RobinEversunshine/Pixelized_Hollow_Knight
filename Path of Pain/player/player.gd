extends CharacterBody2D

var health = 9

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const friction : float = 40.0
const speed : float = 120.0
const max_fall_vel : float = 350.0

var direction
var leave_ground : float = 0
var max_height : float = 0

var is_wall_jump : bool = false

var is_invincible : bool = false
var is_respawn : bool = false
var respawn_activate : bool = true
var hurt_pos : Vector2

var current_checkpoint : Checkpoint

@export var dir : int = -1
@export var camera : Camera2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var effects2 = $Effects/EffectsPlayer2
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine


@onready var shape_cast : ShapeCast2D = $ShapeCast2D
@onready var shape_cast2 = $ShapeCast2D2
@onready var nail_hitbox = $NailHitbox



func _ready():
	animation_tree.active = true
	update_height()


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor() and state_machine.current_state.has_gravity:
		if velocity.y < max_fall_vel:
			velocity.y += gravity * delta
		else:
			velocity.y = max_fall_vel
		leave_ground += delta
		
	if is_on_floor() or shape_cast.is_colliding():
		leave_ground = 0


	
	direction = Input.get_axis("left", "right")
	
	if state_machine.check_if_can_move() and state_machine.current_state.name != "Wall" and not is_wall_jump:
		if direction < 0:
			dir = -1
		elif direction > 0:
			dir = 1

	#run
	if direction and state_machine.check_if_can_move() and not is_wall_jump:
		velocity.x = direction * speed
			
	else:
		velocity.x = move_toward(velocity.x, 0, friction)


	
	update_animation_parameters()
	update_facing_direction()
	move_and_slide()
	
	#hurt on spikes
	if shape_cast2.is_colliding():
		shape_cast2.force_shapecast_update()
		var collision_count = shape_cast2.get_collision_count()
		if collision_count != 0:
			for n in collision_count:
				var collision_tile = shape_cast2.get_collider(n)
				if collision_tile is TileMap:
					var collision_point = shape_cast2.get_collision_point(n)
					var collision_cell = collision_tile.local_to_map(collision_point)
					if collision_tile.get_cell_tile_data(n,collision_cell):
						var spike = collision_tile.get_cell_tile_data(n,collision_cell).get_custom_data("spike")
						if spike == 1:
							respawn()
							hurt_pos = collision_point

	#print(state_machine.check_if_can_move())
	
#	if Game.player_hp == 0:
#		anim.play("hurt")
#		#await get_node("AnimationPlayer").animation_finished
#		get_tree().change_scene_to_file("res://main.tscn")
#		queue_free()


func update_animation_parameters():
	animation_tree.set("parameters/Move/blend_position", direction)


func update_facing_direction():
	if dir == 1:
		get_node("AnimatedSprite2D").flip_h = true
		get_node("Effects/AnimatedSprite2D").flip_h = true
		nail_hitbox.scale.x = -1
	elif dir == -1:
		get_node("AnimatedSprite2D").flip_h = false
		get_node("Effects/AnimatedSprite2D").flip_h = false
		nail_hitbox.scale.x = 1


func hurt():
	if not is_invincible:
		Game.hurt_times += 1
		health -= 1
		is_invincible = true
		effects2.play("hurt_blink")
		state_machine.current_state.next_state = $CharacterStateMachine/Hurt
		await get_tree().create_timer(1).timeout
		is_invincible = false
		effects2.play("RESET")

func update_height():
	max_height = position.y

@onready var air = $CharacterStateMachine/Air


func respawn():
	air.has_double_jumped = false
	air.has_dashed = false
	if Game.instant_death:
		if respawn_activate:
			Game.hurt_times += 1
			health -= 1
			is_invincible = true
			is_respawn = true
			effects2.play("hurt_blink")
			state_machine.current_state.next_state = $CharacterStateMachine/Hurt
			respawn_activate = false
			await get_tree().create_timer(0.2).timeout
			respawn_activate = true
			is_respawn = false
			await get_tree().create_timer(2).timeout
			is_invincible = false
			
			effects2.play("RESET")
	else:
		hurt()
