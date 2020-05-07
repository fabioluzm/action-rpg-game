extends Area2D

### Onready vars ###
onready var timer: = $Timer

### Constants ###
const HITEFFECT = preload("res://src/world/props/hit effect/HitEffect.tscn")

### Signals ###
signal invicibility_started
signal invicibility_ended

### Variables ###
var invicible = false setget set_invicible


### Custom Functions ###
func set_invicible(value) -> void:
	invicible = value
	if invicible == true:
		emit_signal("invicibility_started")
	else:
		emit_signal("invicibility_ended")

func start_invicibility(duration) -> void:
	self.invicible = true
	timer.start(duration)

func create_hit_effect() -> void:
	var effect = HITEFFECT.instance()
	var _game = get_tree().current_scene
	_game.add_child(effect)
	effect.global_position = global_position


### Signal Functions ###
func _on_Timer_timeout() -> void:
	self.invicible = false

func _on_Hurtbox_invicibility_started() -> void:
	set_deferred("monitorable", false)

func _on_Hurtbox_invicibility_ended() -> void:
	monitorable = true
