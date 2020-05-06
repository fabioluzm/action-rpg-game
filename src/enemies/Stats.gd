extends Node2D

export var _MaxHealth: = 0
onready var _health = _MaxHealth setget set_health

signal no_health

func set_health(_value) -> void:
	_health = _value
	if _health <= 0 :
		emit_signal("no_health")
