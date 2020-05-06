extends KinematicBody2D

# onready vars
onready var _BatAnimation: = $BatAnimation
onready var _Stats: = $Stats

# Contants
const _BatDeathEffect: = preload("BatDeathEffect.tscn")

# vars
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
	_Stats._health -= _area._DAMAGE

# Create death effect and destroy node when health reaches 0
func _on_Stats_no_health() -> void:
	# Destroy the node
	queue_free()
	
	# Create the death effect
	create_death_effect()

# Create the Bat Death Effect
func create_death_effect() -> void:
	# Load the BatDeathEffect scene and instantiate it
	var _batDeathEffect = _BatDeathEffect.instance()
	
	# Get the main scene from the tree scene and add a child
	# grass effect instace at the same position of this grass node
	var _Game: = get_tree().current_scene
	_Game.add_child(_batDeathEffect)
	_batDeathEffect.global_position = global_position
	
	# or get the parent node and attached a child to it
	# get_parent().add_child(_batDeathEffect)
	# set the position based on parent position instead of global position
	# _batDeathEffect.position = position
