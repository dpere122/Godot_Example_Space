extends Node2D

@export var weapon_node: PackedScene
@export var weapon_filter : Color = Color(0,0,0,0)
@export var shoot_step: float
@export var damage: int
@export var double_gun: bool
@export var left_gun: Node2D
@export var right_gun: Node2D
@export_category("Enemy Settings")
@export var min_shoot_step: float
@export var max_shoot_step:float


var shot_timer: float
var is_ship_player: bool = false
var owner_node: Node2D
var gun_timer: Timer
var temp_weapon: bool
var timer: float
var dual_gun_pos: Vector2

func _ready():
	if(owner != null):
		if(owner.entity_type == "Player"):
			is_ship_player = true
	if(temp_weapon):
		gun_timer = Timer.new()
		gun_timer.set_wait_time(timer)
		gun_timer.set_one_shot(true)
		self.add_child(gun_timer)
		gun_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(temp_weapon and gun_timer.time_left <= 0):
		queue_free()
	if(is_ship_player):
		if(Input.is_action_pressed("ui_shoot")):
			shot_timer += delta
			if(shot_timer >= shoot_step):
				shoot_main_gun()
				shot_timer = 0
		else:
			shot_timer = 0
	else:
		shot_timer += delta
		if(shot_timer >= randf_range(min_shoot_step,max_shoot_step)):
			shoot_main_gun()
			shot_timer = 0

func shoot_main_gun()-> void: 
	var bullet_scene: PackedScene = load(weapon_node.get_path())
	var bullet_node: Node2D = bullet_scene.instantiate()
	bullet_node.damage = damage
	if(is_ship_player):
		bullet_node.isPlayer = true
	else:
		bullet_node.isPlayer = false
	bullet_node._set_texture_filter(weapon_filter)
	$shoot_sound.play();
	bullet_node.owner_node = owner_node
	bullet_node.position = owner_node.position
		
	get_node("/root").get_child(0).add_child(bullet_node)	


func _on_tree_entered():
	if(owner_node == null):
		if(owner != null):
			if(owner.entity_type == "Player"):
				owner_node = owner
