extends RigidBody2D

@export var MIN_AIR_FRICTION: float = 0.1
@export var AIR_FRICTION_COEF: float = 0.3
@export var MAX_SPEED: float = 800
@export var MIN_SPEED: float = 200
@export var GLIDE_COEF: float = .06
@export var GRAVITY: float = 29
@export var STARTING_HEIGHT: float = 6.0
@export var SKIP_VERTICAL_SPEED_COEF: float = 0.7
@export var MAX_SKIP_SPEED_COEF: float = 1
@export var MIN_SKIP_SPEED: int = 35

@export var speed: int = 5
@export var glide: int = 5
@export var turn: int = 0
@export var fade: int = 0

var height = 0
var vertical_velocity = 0
var grounded = true
var max_h = 0
var skip_speed_coef = (speed / 14.5) * MAX_SKIP_SPEED_COEF
var skip_v_speed = (speed / 14.5)
var throw_ready = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_fric_coef = AIR_FRICTION_COEF + MIN_AIR_FRICTION
	linear_velocity -= current_fric_coef * linear_velocity * delta
	
	if not grounded:
		vertical_velocity += floor(GLIDE_COEF * linear_velocity.length()) * delta
		vertical_velocity -= GRAVITY * delta
		height += vertical_velocity * delta
		
	#print(vertical_velocity / delta, " ", linear_velocity.length(), " ", height)
	
	if height <= 0:
		if linear_velocity.length() > MIN_SKIP_SPEED:
			linear_velocity *= skip_speed_coef
			vertical_velocity = abs((speed / 14.5) * vertical_velocity * SKIP_VERTICAL_SPEED_COEF)
			print("skip")
		else:
			grounded = true
			height = 0
			linear_velocity = Vector2(0, 0)
			vertical_velocity = 0
			
	print(linear_velocity.length(), " ", height)
	
	
	if Input.is_action_just_pressed("Throw") and throw_ready:
		throw()
	if Input.is_action_just_pressed("Ready"):
		height = STARTING_HEIGHT
		throw_ready = true
		
	

func throw():
	var throw_direction = (get_global_mouse_position() - position).normalized()
	linear_velocity = throw_direction * ( (speed / 14.5) * (MAX_SPEED - MIN_SPEED) + MIN_SPEED )
	height = STARTING_HEIGHT
	grounded = false
	throw_ready = false
