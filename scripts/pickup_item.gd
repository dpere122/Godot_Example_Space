extends Area2D

@export_category("Settings")
@export var weapon_list: Array[PackedScene]
@export var random_weapon: bool
@export var temp_weapon: bool
@export var gun_timer: float


var active_wep: PackedScene


func _on_body_entered(body):
	if("entity_type" in body):
		if(random_weapon):
			active_wep = load(weapon_list[randi() % weapon_list.size()].resource_path)
		else:
			active_wep = load(weapon_list[0].resource_path)
		body.add_weapon(active_wep,temp_weapon,gun_timer) 
		queue_free()
