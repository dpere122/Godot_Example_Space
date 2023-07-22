extends Node2D

var isPlayer:bool
@export var weapon_name:String
@export var damage:int
@export var speed:float
#this var will only be used to get passed down into the ship
@export var cooldown:float
var owner_node: Node2D

var x: float
var y: float

var gun_pos: Transform2D

# Called when the node enters the scene tree for the first time.
func _ready():
	global_rotation_degrees = owner_node.rotation_degrees
	
func _set_texture_filter(color:Color) -> void:
	$bullet_sprite.material.set_shader_parameter("Color_Filter",color)

	
func _physics_process(delta):
	if(gun_pos == null):
		y = position.y + ((delta*speed) * sin(rotation_degrees*(PI/180)))
		x = position.x + ((delta*speed) * cos(rotation_degrees*(PI/180)))
	else:
		y = gun_pos.y + ((delta*speed) * sin(rotation_degrees*(PI/180)))
		x = gun_pos.x + ((delta*speed) * cos(rotation_degrees*(PI/180)))
	position = Vector2(x,y)
