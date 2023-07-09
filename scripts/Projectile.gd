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

func _set_texture_filter(color:Color) -> void:
	$bullet_sprite.material.set_shader_parameter("Color_Filter",color)

	
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
	

