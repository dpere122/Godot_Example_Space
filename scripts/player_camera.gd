extends Camera2D

var player_node: Node2D
var last_player_location: Transform2D
@export var damping_rate: float = 25.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#get the player object initially
	attach_to_player()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta)-> void:
	#first off - follow player
	#dampen the following
	position = player_node.global_position
	
	
#Stops following the player object
func detatch_from_player()-> void:
	pass
	
#Attaches to player
func attach_to_player()-> void:
	player_node = get_node("/root/Main_Scene/Player")
