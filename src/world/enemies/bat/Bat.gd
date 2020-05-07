extends KinematicBody2D

# onready vars
onready var _BatAnimation: = $BatAnimation
onready var _Sprite: = $Sprite
onready var _Stats: = $Stats
onready var _PlayerDetection: = $PlayerDetection


# Contants
const _BatDeathEffect: = preload("BatDeathEffect.tscn")

# Exports
export var _ACCELERATION: = 300
export var _MAX_SPEED: = 50
export var _FRICTION: = 200

# Enums
enum {
	IDLE,
	WANDER,
	CHASE
}

# variables
var _velocity: = Vector2.ZERO
var _knockBack: = Vector2.ZERO
var _state = CHASE

func _ready() -> void:
	_BatAnimation.play("Bat")

func _physics_process(_delta: float) -> void:
	_knockBack = _knockBack.move_toward(Vector2.ZERO, _FRICTION * _delta)
	_knockBack = move_and_slide(_knockBack)
	
	match _state:
		IDLE:
			_velocity = _velocity.move_toward(Vector2.ZERO, _FRICTION * _delta)
			seek_player()
		
		WANDER:
			pass
		
		CHASE:
			var _player = _PlayerDetection._player
			if _player != null:
				var _player_direction = (_player.global_position -global_position).normalized()
				_velocity = _velocity.move_toward(_player_direction * _MAX_SPEED, _ACCELERATION * _delta)
			else:
				_state = IDLE
			_Sprite.flip_h = _velocity.x < 0
			
	_velocity = move_and_slide(_velocity)


func seek_player() -> void:
	if _PlayerDetection.can_see_player():
		_state = CHASE

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
