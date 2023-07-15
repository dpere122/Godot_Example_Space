extends Node2D

@export var weapon_node: PackedScene
@export var weapon_filter : Color = Color(0,0,0,0)
@export var shoot_step: float
@export var damage: int
@export var is_infinite: bool
@export var timer: float
@export_category("Enemy Settings")
@export var min_shoot_step: float
@export var max_shoot_step:float


var shot_timer: float
var is_ship_player: bool = false
var owner_node: Node2D

func _ready():
	if(owner != null):
		if(owner.entity_type == "Player"):
			is_ship_player = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	if(owner != null):
		bullet_node.owner_node = owner
		bullet_node.position = owner.position
	else:
		bullet_node.owner_node = owner_node
		bullet_node.position = owner_node.position
			
	get_node("/root").get_child(0).add_child(bullet_node)

