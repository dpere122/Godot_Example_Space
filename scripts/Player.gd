extends CharacterBody2D


@export var SPEED = 300.0

@export var entity_type = "Player"
@export var health : float = 100

var ship_sprite_path : String = ""

var shot_timer: float

func _ready()->void:
	#This can ensure certain features are available if componenets are added
	#Though inheritance could probably be used instead to create a hiearchical
	#structure about the basic function of these objects
	ship_sprite_path = $Space_Ship.get_path()
		

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
#	look_at(get_viewport().get_camera_2d().get_global_mouse_position())
	var mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()
	#Custom rotation
#	print(mouse_pos)
	rotation = atan2(mouse_pos.y-position.y,mouse_pos.x-position.x)
#	rotation = *PI/180
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
	#find a way to respawn player from hub
	#send pod back to hub
	owner.player_restart(self)

func take_damage(amount: int) -> void:
	health -= amount
	flash()
	if(health <= 0):
		destroyed()
		
func add_weapon(weapon :PackedScene) -> void:
	var n_weapon: Node2D = weapon.instantiate()
	n_weapon.is_ship_player = true
	n_weapon.owner_node = self
	add_child(n_weapon)
	n_weapon.position = self.get_global_transform().get_origin()
	

func _on_eff_timer_timeout()-> void:
	if(get_node_or_null(ship_sprite_path) != null):
		$Space_Ship.material.set_shader_parameter("flash_mod",0)


