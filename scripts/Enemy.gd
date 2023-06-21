extends CharacterBody2D


@export var SPEED : float = 300.0
@export var entity_type : String = "Enemy"
@export var health : float = 100
@export var damage : int = 15
@export var weapon_filter : Color = Color(0,0,0,0)
@export var points : int = 1

var rng = RandomNumberGenerator.new()
var curRand

var canvasRect:Rect2
var direction: float = 1

func _ready():
	canvasRect = get_viewport_rect()
	curRand = rng.randf_range(1, 5)
	$shoot_timer.start(curRand)


func _physics_process(delta):
	#Here i need to spawn a bullet.
	#the bullet then has to travel towards the enemies ahead.	
	if $shoot_timer.time_left <= 0:
		shootMainGun()	
		#Here I need to spawn a bullet
		#then use the parent function 
		$shoot_timer.start(curRand)

	if(global_transform.origin.x >= canvasRect.size.x/2):
		direction = -1
		position.y += ($Space_Ship.get_rect().size.y*$Space_Ship.scale.y)
	elif(global_transform.origin.x <= -1*(canvasRect.size.x/2)):
		direction = 1
		position.y += ($Space_Ship.get_rect().size.y*$Space_Ship.scale.y)
		
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	pass

func shootMainGun()-> Node2D: 
	##depending on the bullet I need to change the shoot timer.
	#Each weapon/bullet type needs to have it's own cooldown
	var bullet_scene: PackedScene = load("res://weapons/simple_bullet.tscn")
	var bullet_node: Node2D = bullet_scene.instantiate()
	bullet_node.isPlayer = false
	bullet_node.damage = damage
	bullet_node.position = position
	bullet_node._set_texture_filter(weapon_filter)
	get_parent().add_child(bullet_node)
	return bullet_node
	
func flash()-> void:
	$Space_Ship.material.set_shader_parameter("flash_mod",1)
	$eff_timer.start()

func destroyed() -> void:
	#this function will be called by the bullet that causes hp to go below 0
	var explosion: PackedScene = load("res://static_entity/explosion.tscn")
	var explosion_node: Node2D = explosion.instantiate()
	explosion_node.position = get_global_transform().origin
	get_node("/root").get_child(0).update_kill_counter(points)
	get_node("/root").get_child(0).add_child(explosion_node)
	get_node("/root").get_child(0).update_ship_alive_count(-1)
	queue_free()

func _on_eff_timer_timeout():
	$Space_Ship.material.set_shader_parameter("flash_mod",0)


func take_damage(amount: int) -> void:
	health -= amount
	flash()
	if(health <= 0):
		destroyed()
		



