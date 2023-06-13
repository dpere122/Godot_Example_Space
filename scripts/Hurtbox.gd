class_name Hurtbox
extends Area2D


func _init() -> void:
	collision_layer = 0
	collision_mask = 2
	
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered",Callable(self,"_on_area_entered"))
	
func _on_area_entered(hitbox:Hitbox) ->void:
	if hitbox == null:
		return
	if (hitbox.owner.isPlayer and owner.entity_type == "Enemy"):
		if owner.has_method("take_damage"):
			owner.take_damage(hitbox.damage)
			hitbox.owner.queue_free()
	elif(!hitbox.owner.isPlayer and owner.entity_type == "Player"):
		if owner.has_method("take_damage"):
			owner.take_damage(hitbox.damage)
			hitbox.owner.queue_free()
