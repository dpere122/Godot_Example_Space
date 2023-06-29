extends Node

@export var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_kill_counter(amount:int) -> void:
	score += amount
	$KillCounter/Label.text = str('Score: ',score)
	
func update_ship_alive_count(amount:int) -> void:
	if($Ship_Spawner.live_ships > 0):
		update_kill_counter(amount)
		$Ship_Spawner.live_ships += -1

func player_restart(ship:CharacterBody2D) -> void:
	free_ship(ship)
	var t = Timer.new()
	t.set_wait_time(5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()
	
	get_tree().change_scene_to_file("res://Levels/end_scene.tscn")

func free_ship(ship:CharacterBody2D) -> void:
	ship.queue_free()
