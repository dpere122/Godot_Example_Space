extends CharacterBody2D


@export var SPEED = 300.0

@export var entity_type = "Player"
@export var health : float = 100
@export var damage : int = 50
@export var weapon_filter : Color = Color(0,0,0,0)

var ship_sprite_path : String = ""

func _ready()->void:
	#This can ensure certain features are available if componenets are added
	#Though inheritance could probably be used instead to create a hiearchical
	#structure about the basic function of these objects
	ship_sprite_path = $Space_Ship.get_path()

func _input(event)->void:
	if(event.is_action_pressed("ui_console")):
		toggle_pause()

func _physics_process(delta):
	#Here i need to spawn a bullet.
	#the bullet then has to travel towards the enemies ahead.
	if Input.is_action_just_released("ui_shoot"):
		shootMainGun()
#		if $shoot_timer.time_left <= 0:
#			#Here I need to spawn a bullet
#			#then use the parent function 
#			$shoot_timer.start(-bullet_instance.cooldown)
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func shootMainGun()-> Node2D: 
	##depending on the bullet I need to change the shoot timer.
	#Each weapon/bullet type needs to have it's own cooldown
	var bullet_scene: PackedScene = load("res://weapons/simple_bullet.tscn")
	var bullet_node: Node2D = bullet_scene.instantiate()
	bullet_node.damage = damage
	bullet_node.isPlayer = true
	bullet_node._set_texture_filter(weapon_filter)
	$"shoot_sound".play();
	bullet_node.position = position
	get_parent().add_child(bullet_node)
	return bullet_node
	
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
	
	var t = Timer.new()
	t.set_wait_time(5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()
	
	get_tree().change_scene_to_file("res://Levels/end_scene.tscn")
	queue_free()

func take_damage(amount: int) -> void:
	health -= amount
	flash()
	if(health <= 0):
		destroyed()

func _on_eff_timer_timeout()-> void:
	if(get_node_or_null(ship_sprite_path) != null):
		$Space_Ship.material.set_shader_parameter("flash_mod",0)

func toggle_pause() -> void:
	if(!get_tree().paused):
		get_tree().paused = true
		print(get_tree().paused)
	else:
		get_tree().paused = false
		print(get_tree().paused)
