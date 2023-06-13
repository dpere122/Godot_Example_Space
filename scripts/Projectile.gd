extends Node2D

var isPlayer:bool
var canvasRect:Rect2
@export var weapon_name:String
@export var damage:float
@export var speed:float
#this var will only be used to get passed down into the ship
@export var cooldown:float

# Called when the node enters the scene tree for the first time.
func _ready():
	canvasRect = get_viewport_rect()
	if(!isPlayer):
		rotation_degrees = 180


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	#destroy object if it goes past the screen
	if(global_transform.origin.y >= canvasRect.size.y/2):
		queue_free()
	elif(global_transform.origin.y <= -canvasRect.size.y/2):
		queue_free()
		
	if(isPlayer):
		position.y -= speed *delta
	else:
		position.y += speed *delta
	

#if bullet hits object then do damage to it as long as it's either an enemy or player
#func _on_area_2d_body_entered(body) -> void:
#	if(isPlayer and body.entity_type == "Enemy"):
#		body.health -= damage
#		print(body.name,":",body.health)
#		if(body.health <= 0):
#			body.destroyed()
#	elif(!isPlayer and body.entity_type == "Player"):
#		body.health -= damage
#		if(body.health <= 0):
#			body.destroyed()


