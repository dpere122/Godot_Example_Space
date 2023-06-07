extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#var camera : Camera2D
#var centerOfScreen:Vector2
#var viewportX:int
var canvasRect:Rect2
var direction: float = 1

func _ready():
	#var camera = get_tree().get_root().get_camera_2d()
	#centerOfScreen = camera.get_screen_center_position()
	#get the viewport of the camera
	#var camViewport = camera.get_viewport()
	#viewportX = camViewport.get
	canvasRect = get_viewport_rect()
	
	

func _physics_process(delta):
	#Here i need to spawn a bullet.
	#the bullet then has to travel towards the enemies ahead.
#	if Input.is_action_just_released("ui_shoot"):
#		var bullet_instance : Node2D = shootMainGun()	
#		if $shoot_timer.time_left <= 0:
#			#Here I need to spawn a bullet
#			#then use the parent function 
#			$shoot_timer.start(-bullet_instance.cooldown)

	if(global_transform.origin.x >= canvasRect.size.x/2):
		direction = -1
		print("hit right| Direction: ",direction)
	elif(global_transform.origin.x <= -1*(canvasRect.size.x/2)):
		direction = 1
		print("hit left| Direction: ",direction)
	if direction != 0:
		velocity.x = direction * SPEED
		print("Direction: ",direction)
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
	

