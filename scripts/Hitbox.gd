class_name Hitbox
extends Area2D

@export var damage = 10



func _init() -> void:
	collision_layer = 2
	collision_mask = 0

func _ready() -> void:
	#if the owner of this script has a damage attribute then use that
	if("damage" in owner):
		damage = owner.damage

