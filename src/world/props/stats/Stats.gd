extends Node2D


### Exports ###
export var max_health: = 1 setget set_max_health
export var invicible_time: = 0.5

### Signals ###
signal no_health
signal health_changed(value)
signal max_health_changed(value)

### Variabless ###
var health = max_health setget set_health

### Ready Function ###
func _ready() -> void:
	self.health = max_health

### Set Functions ###
func set_max_health(value) -> void:
	max_health = value
	self.health = min(health, max_health)
	
	emit_signal("max_health_changed", max_health)
 
func set_health(value) -> void:
	health = value
	
	emit_signal("health_changed", health)
	
	if health <= 0 :
		emit_signal("no_health")
