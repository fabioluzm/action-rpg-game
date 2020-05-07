extends KinematicBody2D

### Exports ###
export var _ACCELERATION: = 300
export var _MAX_SPEED: = 50
export var _FRICTION: = 200

### Onready vars ###
onready var BatAnimation: = $BatAnimation
onready var Sprite: = $Sprite
onready var Stats: = $Stats
onready var PlayerDetection: = $PlayerDetection
onready var HurtBox: = $Hurtbox

### Contants ###
const _BATDEATHEFFECT: = preload("res://src/world/enemies/bat/BatDeathEffect.tscn")

### Enums ###
enum {
	IDLE,
	WANDER,
	CHASE
}

### Variables ###
var _velocity: = Vector2.ZERO
var _knockBack: = Vector2.ZERO
var _state = CHASE


### Onready Function ###
func _ready() -> void:
	BatAnimation.play("Bat")

### Physics and Process Functions ##
func _physics_process(delta: float) -> void:
	_knockBack = _knockBack.move_toward(Vector2.ZERO, _FRICTION * delta)
	move(_knockBack)
	
	match _state:
		IDLE:
			_velocity = _velocity.move_toward(Vector2.ZERO, _FRICTION * delta)
			seek_player()
		
		WANDER:
			pass
		
		CHASE:
			chase_player(delta)
			
	move(_velocity)


### Custom Functions ###
func create_death_effect() -> void:
	# Load the BatDeathEffect scene and instantiate it
	var batDeathEffect = _BATDEATHEFFECT.instance()
	
	# Attach instance to parent node and set position
	get_parent().add_child(batDeathEffect)
	batDeathEffect.global_position = global_position

func move(argument):
	argument = move_and_slide(argument)

func set_health(area) -> void:
	Stats.health -= area.damage

### State Funtions ###
func seek_player() -> void:
	if PlayerDetection.can_see_player():
		_state = CHASE

func chase_player(delta: float) -> void:
	var player = PlayerDetection.player
	
	if player != null:
		var player_direction = (player.global_position - global_position).normalized()
		_velocity = _velocity.move_toward(player_direction * _MAX_SPEED, _ACCELERATION * delta)
	else:
		_state = IDLE
	
	Sprite.flip_h = _velocity.x < 0


### Signal Functions ###
func _on_Hurtbox_area_entered(area: Area2D) -> void:
	set_health(area)
	_knockBack = area.knockback_direction * 120
	HurtBox.create_hit_effect()

# Create death effect and destroy node when health reaches 0
func _on_Stats_no_health() -> void:
	# Destroy the node
	queue_free()
	
	# Create the death effect
	create_death_effect()
