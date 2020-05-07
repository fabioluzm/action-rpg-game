extends KinematicBody2D

### Exports ###
export var _PLAYER_MAX_SPEED: = 80
export var _PLAYER_ACCELERATION: = 500
export var _PLAYER_FRICTION: = 500
export var _PLAYER_ROLL_SPEED: = 100

### Onready vars ###
onready var _animationPlayer: AnimationPlayer = $AnimationPlayer
onready var _animationTree: AnimationTree = $AnimationTree
onready var _animationState = _animationTree.get("parameters/playback")
onready var _swordHitBox: = $HitboxPivot/SwordHitbox
onready var hurtbox: = $Hurtbox

### Enums ###
# Enumerate the diferent game states
enum {
	MOVE,
	ROLL,
	ATTACK
}

### Variables ###
var _state: = MOVE
var _velocity: = Vector2.ZERO
var _roll_direction: = Vector2.DOWN
var stats = PlayerStats

### Onready Function ###
func _ready() -> void:
	# Connect to the stats signal
	stats.connect("no_health", self, "queue_free")
	# Start animation tree on game start
	_animationTree.active = true
	# Get the sword knockback direction
	_swordHitBox.knockback_direction = _roll_direction

### Physics and Process Functions ###
func _physics_process(_delta: float) -> void:
	
	match _state:
		MOVE:
			# State when the player is moving
			move_state()
		
		ROLL:
			# State when the player is rolling
			roll_state()
		
		ATTACK:
			# State when the player is attacking
			attack_state()

### Custom Functions ###
# Player directional movement
func get_direction() -> Vector2:
	var _direction: = Vector2.ZERO
	_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	_direction = _direction.normalized()
	return Vector2(_direction)

# Player motion speed based on velocity
func get_motion_speed(
		_linear_velocity: Vector2,
		_movement: Vector2,
		_speed: int,
		_acceleration: int,
		_friction: int
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

# Start Moving function
func move() -> Vector2:
	_velocity = move_and_slide(_velocity)
	return Vector2(_velocity)

func set_health() -> void:
	stats.health -= 1

### State Functions ###
func move_state() -> void:
	# Player movement direction
	# This is the direction that player is moving to
	var _movement: = get_direction()
	
	# Player motion
	# This is the player movement speed and directional animation
	_velocity = get_motion_speed(_velocity, _movement, _PLAYER_MAX_SPEED, _PLAYER_ACCELERATION, _PLAYER_FRICTION)
	
	# Start the movement
	move()
	
	# Stops the current movement and switch to the attack state
	if Input.is_action_just_pressed("ui_attack"):
		_state = ATTACK
	elif Input.is_action_just_pressed("ui_roll"):
		_state = ROLL
	else: 
		_state = MOVE

func roll_state() -> void:
	# Set Roll velocity
	_velocity = _roll_direction * _PLAYER_ROLL_SPEED
	# Get the Roll animation
	get_animation(Vector2.ZERO,"Roll")
	# Start the movement
	move()

func attack_state() -> void:
	# Reset the _velocity to zero
	_velocity = Vector2.ZERO
	# Get the attack animation
	get_animation(Vector2.ZERO,"Attack")

# Switch back to the MOVE state when the attack animation finishes
func attack_animation_finished() -> void:
	_state = MOVE

# Switch back to the MOVE state when the roll animation finishes
func roll_animation_finished() -> void:
	_velocity = Vector2.ZERO
	_state = MOVE

### Animation Funtions ###
# Player moving animations based on direction
func get_animation(
		_direction:Vector2,
		_animation:String
	) -> void:
	if _direction != Vector2.ZERO:
		# get the direction for the animations
		get_anim_direction(_direction)
		
		_animationTree.set("parameters/Idle/blend_position", _direction)
		_animationTree.set("parameters/Run/blend_position", _direction)
		_animationTree.set("parameters/Attack/blend_position", _direction)
		_animationTree.set("parameters/Roll/blend_position", _direction)
		
		_animationState.travel(_animation)
	else:
		_animationState.travel(_animation)

# Directions for the animations
func get_anim_direction(_direction: Vector2) -> void:
	_roll_direction = _direction
	_swordHitBox.knockback_direction = _direction

### Signal Functions ###
func _on_Hurtbox_area_entered(_area: Area2D) -> void:
	set_health()
	hurtbox.start_invicibility(stats.invicible_time)
	hurtbox.create_hit_effect()
