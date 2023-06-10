extends CharacterBody2D


@export var SPEED : float = 300.0
@export var entity_type : String = "Enemy"
@export var health : float = 100
@export var damage : int = 15

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
		position.y -= ($Space_Ship.get_rect().size.y*$Space_Ship.scale.y)
	elif(global_transform.origin.x <= -1*(canvasRect.size.x/2)):
		direction = 1
		position.y -= ($Space_Ship.get_rect().size.y*$Space_Ship.scale.y)
		
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
	get_node("/root").add_child(explosion_node)
	queue_free()


func _on_area_2d_area_entered(area):
	var curCollide = area.owner
	if(curCollide.name == "Simple_bullet" and curCollide.isPlayer):
		health -= curCollide.damage
		curCollide.queue_free()
		flash()
		if(health <= 0):
			destroyed()


func _on_eff_timer_timeout():
	$Space_Ship.material.set_shader_parameter("flash_mod",0)
