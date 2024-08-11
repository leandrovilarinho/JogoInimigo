extends Area2D

var SPEED = 300
var direction

func _ready():
	direction = Vector2.RIGHT.rotated(rotation)
	

func _physics_process(delta):
	var velocity = direction * SPEED * delta
	
	position += velocity

# Sempre que a bala colidir com um corpo (como por exemplo, o Tilemap ou o inimigo)
func _on_body_entered(body):
	if body is Enemy:
		#Global.enemy_shooted.emit(body)
		body.take_damage(1)
	
	if body is Player:
		#Global.player_shooted.emit(body)
		body.take_damage(1)
	
	queue_free() # Remove o elemento (bala) da cena
	
