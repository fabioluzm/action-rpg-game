extends Node2D

export var MaxHealth: = 1
export var InvicibleTime: = 0.5

onready var health = MaxHealth setget set_health

signal no_health

func set_health(value) -> void:
	health = value
	if health <= 0 :
		emit_signal("no_health")
