extends CharacterBody2D

class_name Enemy

var player:CharacterBody2D
var alert = false
var energy:int = 2

var bullet:PackedScene = load("res://scenes/bullet_enemy.tscn")
@onready var marker_2d = $Marker2D
@onready var timer = $Timer


func _ready():
	player = get_tree().root.get_node("Main/Player")
	pass
	
func _process(delta):
	if alert == true:
		if player:
			look_at( player.global_position )
		
		var dir = player.global_position - global_position
		velocity = dir.normalized() * 200
		move_and_slide()

# Função chamada externamente para diminuir a energia do inimigo
func take_damage(damage):
	energy -= damage
	if energy <= 0:
		queue_free()
	
func fire():
	var b = bullet.instantiate()
	b.global_position = marker_2d.global_position
	b.rotation_degrees = rotation_degrees
	get_tree().root.add_child(b)

# Quando o Player entra na área de vigia do inimigo
# Entra em estado de alerta
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		alert = true
		timer.start()
		

# Quando o Player sai da área de vigia do inimigo
# Sai do estado de alerta
func _on_area_2d_body_exited(body):
	if body.name == "Player":
		alert = false
		timer.stop()

# Chamado sempre que o timer chegar ao fim
func _on_timer_timeout():
	fire()
