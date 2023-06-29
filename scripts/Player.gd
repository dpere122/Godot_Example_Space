extends CharacterBody2D


@export var SPEED = 300.0

@export var entity_type = "Player"
@export var health : float = 100
@export var damage : int = 50
@export var weapon_filter : Color = Color(0,0,0,0)

@export var weapons : Array[PackedScene]

var ship_sprite_path : String = ""

var shot_timer: float

func _ready()->void:
	#This can ensure certain features are available if componenets are added
	#Though inheritance could probably be used instead to create a hiearchical
	#structure about the basic function of these objects
	ship_sprite_path = $Space_Ship.get_path()
		

func _physics_process(delta):
	if(Input.is_action_pressed("ui_shoot")):
		shot_timer += delta
		if(shot_timer >= 0.2):
			shot_main_gun()
			shot_timer = 0
	else:
		shot_timer = 0
		
	# Get the input direction and handle the movement/deceleration.
	var direction : Vector2
	direction = move_in_zone()
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()

	
func move_in_zone() -> Vector2:
	var direction: Vector2
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return direction
	
func shot_main_gun()-> void: 
	##depending on the bullet I need to change the shoot timer.
	#Each weapon/bullet type needs to have it's own cooldown
#	var bullet_scene: PackedScene = load("res://weapons/Blue_bullet.tscn")
#	var last_shot_dict: Dictionary = {}
#	if(fmod(snapped(shot_timer,0.001),0.500) == snapped(0.000,0.001)):
	var bullet_scene: PackedScene = load(weapons[0].get_path())
	var bullet_node: Node2D = bullet_scene.instantiate()
	bullet_node.damage = damage
	bullet_node.isPlayer = true
	bullet_node._set_texture_filter(weapon_filter)
	$shoot_sound.play();
	bullet_node.position = position
	get_parent().add_child(bullet_node)
	print(snapped(shot_timer,0.001))
	
func flash()-> void:
	if(get_node_or_null(ship_sprite_path) != null):
		$Space_Ship.material.set_shader_parameter("flash_mod",1)
		$eff_timer.start()
	
func destroyed() -> void:
	#this function will be called by the bullet that causes hp to go below 0
	var explosion: PackedScene = load("res://static_entity/explosion.tscn")
	var explosion_node: Node2D = explosion.instantiate()
	explosion_node.position = get_global_transform().origin
	$Space_Ship.queue_free()
	$Hurtbox.queue_free()
	get_node("/root").add_child(explosion_node)
	owner.player_restart(self)

func take_damage(amount: int) -> void:
	health -= amount
	flash()
	if(health <= 0):
		destroyed()

func _on_eff_timer_timeout()-> void:
	if(get_node_or_null(ship_sprite_path) != null):
		$Space_Ship.material.set_shader_parameter("flash_mod",0)


