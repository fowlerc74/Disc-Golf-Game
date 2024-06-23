extends RigidBody2D

@export var MIN_AIR_FRICTION: float = 0.01
@export var AIR_FRICTION_COEF: float = 0.01
@export var SPEED_COEF: float = 200
@export var GRAVITY_ACCEL: float = 0.05
@export var GLIDE_INITIAL_COEF: float = 0.00009
@export var GLIDE_RESISTANCE: float = 0.01
@export var STARTING_HEIGHT: float = 6.0
@export var MAX_SKIP_VERTICAL_SPEED: float = 0.5
@export var MAX_SKIP_SPEED_COEF: float = 1
@export var MIN_SKIP_SPEED: int = 20

@export var speed: int = 10
@export var glide: int = 5
@export var turn: int = 0
@export var fade: int = 0

var height = 0
var vertical_velocity = 0
var grounded = false
var max_h = 0
var skip_speed_coef = (speed / 14.5) * MAX_SKIP_SPEED_COEF
var skip_v_speed = (speed / 14.5) * MAX_SKIP_VERTICAL_SPEED

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_fric_coef = AIR_FRICTION_COEF * linear_velocity.length() + MIN_AIR_FRICTION
	linear_velocity *= (1 - current_fric_coef * delta) 
	
	if not grounded:
		vertical_velocity = vertical_velocity - GLIDE_RESISTANCE
		height += vertical_velocity * delta
	
	if height <= 0:
		if linear_velocity.length() > MIN_SKIP_SPEED:
			linear_velocity *= skip_speed_coef
			vertical_velocity = skip_v_speed
			print("skip")
		else:
			grounded = true
			height = 0
			linear_velocity = Vector2(0, 0)
			
	print(linear_velocity.length(), " ", height)
	
	
	if Input.is_action_just_pressed("Throw"):
		throw()
	

func throw():
	linear_velocity = (get_global_mouse_position() - position).normalized() * SPEED_COEF * speed
	vertical_velocity = linear_velocity.length() * glide * GLIDE_INITIAL_COEF
	height = STARTING_HEIGHT
	grounded = false
