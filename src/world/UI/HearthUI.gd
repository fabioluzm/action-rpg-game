extends Control

### Onready vars ###
onready var heartUIEmpty: = $HeartUIEmpty
onready var heartUIFull: = $HeartUIFull

### variables ###
var hearts: = 4 setget set_hearts
var max_hearts: = 4 setget set_max_hearts


### Ready Function ###
func _ready() -> void:
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")

### Set Functions ###
func set_max_hearts(value) -> void:
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 15

func set_hearts(value) -> void:
	hearts = clamp(value, 0, max_hearts)
	
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 15

