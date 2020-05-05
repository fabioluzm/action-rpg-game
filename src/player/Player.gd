extends KinematicBody2D

export var _PLAYER_MAX_SPEED: = 80.0
export var _PLAYER_ACCELERATION: = 500.0
export var _PLAYER_FRICTION: = 500.0

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state: = MOVE
var _velocity: = Vector2.ZERO

# Access to the player animation
onready var _animationPlayer: AnimationPlayer = $AnimationPlayer
onready var _animationTree: AnimationTree = $AnimationTree
onready var _animationState = _animationTree.get("parameters/playback")


func _ready() -> void:
	# Start animation tree on game start
	_animationTree.active = true

# Runs every physics steps
func _physics_process(_delta: float) -> void:
	
	match state:
		MOVE:
			# state when the player is moving
			move_state()
		
		ROLL:
			# state when the player is rolling
			roll_state()
		
		ATTACK:
			# state when the player is attacking
			attack_state()



func move_state() -> Vector2:
	# Player movement direction
	# this is the direction that player is moving to
	var _movement: = get_direction()
	
	# Player motion
	# this is the player movement speed and directional animation
	_velocity = get_motion_speed(_velocity, _movement, _PLAYER_MAX_SPEED, _PLAYER_ACCELERATION, _PLAYER_FRICTION)
	_velocity = move_and_slide(_velocity)
	
	# Stops the current movement and switch to the attack state
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK
	
	return Vector2(_velocity)

func roll_state() -> Vector2:
	return Vector2()

func attack_state() -> void:
	var _direction: = get_direction()
	_velocity = Vector2.ZERO

	get_animation(_direction,"Attack")


func attack_animation_finished() -> void:
	state = MOVE

# Player movement
func get_direction() -> Vector2:
	var _direction: = Vector2.ZERO
	_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	_direction = _direction.normalized()
	return Vector2(_direction)

# Player motion speed base on velocity
func get_motion_speed(
		_linear_velocity: Vector2,
		_movement: Vector2,
		_speed: float,
		_acceleration: float,
		_friction: float
	) -> Vector2:
	var _motion: = _linear_velocity
	
	# motion speed and directional animations
	if _movement != Vector2.ZERO:
		get_animation(_movement,"Run")
		_motion = _motion.move_toward(_movement * _speed, _acceleration * get_physics_process_delta_time())
	else:
		get_animation(Vector2.ZERO,"Idle")
		_motion = _motion.move_toward(Vector2.ZERO, _friction)
	
	return Vector2(_motion)

# Player animations based on direction
func get_animation(
		_direction:Vector2,
		_animation:String
	) -> void:
	
	
	if _direction != Vector2.ZERO:
		_animationTree.set("parameters/Idle/blend_position", _direction)
		_animationTree.set("parameters/Run/blend_position", _direction)
		_animationTree.set("parameters/Attack/blend_position", _direction)
		
		_animationState.travel(_animation)
	else:
		_animationState.travel(_animation)
