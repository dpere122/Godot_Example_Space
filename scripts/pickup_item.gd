extends Area2D

@export var weapon_list: Array[PackedScene]
var active_weapon_component: PackedScene

func _ready():
	pass


func _on_body_entered(body):
	if("entity_type" in body):
		print(body.name)
