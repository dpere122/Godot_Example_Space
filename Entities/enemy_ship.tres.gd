extends CharacterBody2D


const SPEED = 300.0

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
	bullet_node.position = position
	get_parent().add_child(bullet_node)
	return bullet_node
	

