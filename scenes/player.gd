extends CharacterBody2D

class_name Player

const SPEED = 300.0

var energy:int = 5

@export var bullet:PackedScene
@onready var marker_2d = $Marker2D

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * SPEED
	
	var mouse = get_global_mouse_position()
	look_at(mouse)
	
	if Input.is_action_just_pressed("fire"):
		fire()
	
	# Movimenta baseado em velocity
	move_and_slide()

func take_damage(damage):
	energy -= damage
	if energy <= 0:
		queue_free()

func fire():
	var b = bullet.instantiate()
	b.global_position = marker_2d.global_position
	b.rotation_degrees = rotation_degrees
	get_tree().root.add_child(b)
	
	
	
	
	
