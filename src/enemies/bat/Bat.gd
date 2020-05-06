extends KinematicBody2D

onready var _BatAnimation: = $BatAnimation
onready var _Stats: = $Stats



var _knockBack: = Vector2.ZERO

func _ready() -> void:
	_BatAnimation.play("Bat")

func _physics_process(_delta: float) -> void:
	_knockBack = _knockBack.move_toward(Vector2.ZERO, 200 * _delta)
	_knockBack = move_and_slide(_knockBack)


func _on_Hurtbox_area_entered(_area: Area2D) -> void:
#	set_health(_area)
	_Stats._health -= _area._DAMAGE
	_knockBack = _area._knockback_direction * 120

func set_health(_area) -> void:
	_Stats._health -= _area._damage


func _on_Stats_no_health() -> void:
	queue_free()
