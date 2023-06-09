extends CharacterBody2D


@export var SPEED = 300.0
@export var entity_type = "Enemy"
@export var health = 100

var canvasRect:Rect2
var direction: float = 1

func _ready():
	canvasRect = get_viewport_rect()
	
	

func _physics_process(delta):
	#Here i need to spawn a bullet.
	#the bullet then has to travel towards the enemies ahead.	
	if $shoot_timer.time_left <= 0:
		var bullet_instance : Node2D = shootMainGun()	
		#Here I need to spawn a bullet
		#then use the parent function 
		$shoot_timer.start(-bullet_instance.cooldown)

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
	bullet_node.damage = 10
	bullet_node.position = position
	get_parent().add_child(bullet_node)
	return bullet_node
	

func destroyed() -> void:
	#this function will be called by the bullet that causes hp to go below 0
	var explosion: PackedScene = load("res://static_entity/explosion.tscn")
	var explosion_node: Node2D = explosion.instantiate()
	explosion_node.position = get_global_transform().origin
	get_node("/root").add_child(explosion_node)
	queue_free()
