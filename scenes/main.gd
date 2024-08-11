extends Node2D


const TILE_SIZE = 64

@onready var tileMap = $TileMap
@onready var player = $Player
@onready var furnitures = $Furnitures

var sofa_3_lugares:PackedScene = preload("res://scenes/furniture/sofa_3_lugares.tscn")

func _ready():
	randomize()
	generate_level()
	configure_game()
	generate_furniture()

func generate_furniture():
	var point = Global.map.pick_random()
	
	var furni = sofa_3_lugares.instantiate()
	# Se virado para baixo
	furni.global_position = point * TILE_SIZE + Vector2(0, TILE_SIZE/2)
	furni.rotation_degrees += 180
	furnitures.add_child(furni)
	
	pass
	
	
func configure_game():
	# Escutar o sinal de inimigo acertado (Global.enemy_shooted)
	Global.enemy_shooted.connect(_on_enemy_shooted)
	

func _on_enemy_shooted(target):
	target.queue_free()

func generate_level():
	var walker = Walker.new(tileMap)
	#var map
	var is_ok = false
	while not is_ok:
		Global.map = walker.walk(250)
		is_ok = check_walk_points(Global.map)
		
	# Player aqui
	player.position = Global.map.front() * TILE_SIZE
	#$Enemy.position = player.position + Vector2(300, 0)
	$Enemy.position = Global.map.pick_random() * TILE_SIZE
	
	walker.queue_free()
	
	var cells = []
	for location in Global.map:
		cells.append(location)
	tileMap.set_cells_terrain_connect(1, cells, 0, -1)
	
	#print(map)
	pass

func check_walk_points(steps):
	print("Checou mapa")
	var rect:Rect2i = tileMap.get_used_rect()
	var tiles:Array = []
	for x in range(1, rect.size.x-1):
		for y in range(1, rect.size.y-1):
			tiles.append(str(x)+"_"+str(y))
	var before = tiles.size()
	
	for step:Vector2 in steps:
		tiles.erase(str(step.x)+"_"+str(step.y))
	
	return true if tiles.size() < before/2 else false
	pass
	

func reload_level():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()
