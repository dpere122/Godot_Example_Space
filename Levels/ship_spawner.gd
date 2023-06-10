extends Node2D

var rng = RandomNumberGenerator.new()
@export var levels: Array = [10,12,15]
var current_spawned:int = 0
var current_cooldown:float = 2
var current_level:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(-current_cooldown)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Timer.time_left <= 0:
		print("tick")
		spawn_ship()

func spawn_ship() -> void:
	if(current_spawned >= levels[current_level]):
		print("NEW_WAVE")		
		current_cooldown -= 0.5
		current_level += 1
		current_spawned = 0
	else:
		var ship_node: PackedScene = load("res://Entities/Enemy.tscn")
		var ship: Node2D = ship_node.instantiate()
		ship.position = get_global_transform().origin
		get_node("/root").add_child(ship)
		current_spawned += 1
	$Timer.start(current_cooldown)
