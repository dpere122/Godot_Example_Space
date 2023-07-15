extends CharacterBody2D


@export var SPEED : float = 300.0
@export var entity_type : String = "Enemy"
@export var health : float = 100
@export var points : int = 1


var canvasRect:Rect2
var direction: float = 1

func _ready():
	canvasRect = get_viewport_rect()


func _physics_process(delta):
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

	
func flash()-> void:
	$Space_Ship.material.set_shader_parameter("flash_mod",1)
	$eff_timer.start()

func destroyed() -> void:
	#this function will be called by the bullet that causes hp to go below 0
	var explosion: PackedScene = load("res://static_entity/explosion.tscn")
	var explosion_node: Node2D = explosion.instantiate()
	explosion_node.position = get_global_transform().origin
	get_node("/root").get_child(0).free_ship(self)
	get_node("/root").get_child(0).update_ship_alive_count(points)
	get_node("/root").get_child(0).add_child(explosion_node)


func _on_eff_timer_timeout():
	$Space_Ship.material.set_shader_parameter("flash_mod",0)


func take_damage(amount: int) -> void:
	health -= amount
	flash()
	if(health <= 0):
		destroyed()
		



