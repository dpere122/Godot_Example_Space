extends Node2D

var rng = RandomNumberGenerator.new()
@export var levels: Array = [5,5,5]
var current_spawned:int = 0
var current_cooldown:float = 0.5
var current_level:int = 0
var live_ships:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(-(current_cooldown/2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Timer.time_left <= 0:
		spawn_ship()

func spawn_ship() -> void:
	if(current_level < levels.size()):
		if(current_spawned >= levels[current_level]):
			print("NEW_WAVE")		
			current_cooldown -= 0.5
			current_level += 1
			current_spawned = 0
		else:
			var ship_node: PackedScene = load("res://Entities/Enemy.tscn")
			var ship: Node2D = ship_node.instantiate()
			ship.position = get_global_transform().origin
			get_node("/root").get_child(0).add_child(ship)
			live_ships += 1
			current_spawned += 1
		$Timer.start(current_cooldown)
	elif(live_ships == 0):
		var t = Timer.new()
		t.set_wait_time(3)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		await t.timeout
		t.queue_free()
		
		get_tree().change_scene_to_file("res://Levels/end_scene.tscn")

