extends RigidBody2D

# To make less exponential, min/max air closer together, min/max speed further apart

@export var MIN_AIR_FRIC_COEF: float = 0.07
@export var MAX_AIR_FRIC_COEF: float = 0.07
@export var MAX_SPEED: float = 1350
@export var MIN_SPEED: float = 700
@export var GLIDE_COEF: float = 8
@export var GRAVITY: float = 35
@export var STARTING_HEIGHT: float = 6.0
@export var TURN_COEF: float = .06
@export var FADE_COEF: float = .18
@export var FADE_SPEED: float = 1
@export var FADE_OFFSET: float = 0
@export var SKIP_VERTICAL_SPEED_COEF: float = 0.7
@export var MAX_SKIP_SPEED_COEF: float = .75
@export var MIN_SKIP_SPEED_COEF: float = .4
@export var MIN_SKIP_SPEED: int = 10

@export var speed: int = 12
@export var glide: int = 5
@export var turn: int = -2
@export var fade: int = 2

var height = 0
var vertical_velocity = 0
var disc_angle = 0
var angle_velocity = 0
var grounded = true
var max_h = 0
var skip_speed_coef = (speed / 14.5) * (MAX_SKIP_SPEED_COEF - MIN_SKIP_SPEED_COEF) + MIN_SKIP_SPEED_COEF
var throw_ready = false
var max_speed = ((speed / 14.5) * (MAX_SPEED - MIN_SPEED) + MIN_SPEED)
var starting_position = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_fric_coef = (-speed / 14.5 + 1) * (MAX_AIR_FRIC_COEF - MIN_AIR_FRIC_COEF) + MIN_AIR_FRIC_COEF
	linear_velocity -= current_fric_coef * linear_velocity * delta
	
	if not grounded:
		var ratio_to_top_speed = linear_velocity.length() / max_speed
		vertical_velocity += GLIDE_COEF * glide * ratio_to_top_speed * delta
		vertical_velocity -= GRAVITY * delta
		height += vertical_velocity * delta
	
		var current_speed = linear_velocity.length()
		#var angle = acos(linear_velocity.x/linear_velocity.length())
		var turn = turn * TURN_COEF * (speed / 14.5) * (current_speed / max_speed) * delta
		var fade = max(fade * FADE_COEF * (speed / 14.5) * (max_speed - current_speed) / max_speed - FADE_OFFSET, 0) * delta
		angle_velocity = turn + fade
		disc_angle = (angle_velocity + disc_angle) 
		print(disc_angle, " ", turn, " ", fade, " ", angle_velocity)
		
		
		
		#print(linear_velocity.length(), " ", vertical_velocity, " ", height)
	
	if height <= 0:
		if linear_velocity.length() > MIN_SKIP_SPEED:
			linear_velocity *= skip_speed_coef
			vertical_velocity = abs((speed / 14.5) * vertical_velocity * SKIP_VERTICAL_SPEED_COEF) 
			
		else:
			grounded = true
			height = 0
			linear_velocity = Vector2(0, 0)
			vertical_velocity = 0
	
	if Input.is_action_just_pressed("Throw") and throw_ready:
		throw()
	if Input.is_action_just_pressed("Ready"):
		height = STARTING_HEIGHT
		throw_ready = true
		print("----------------------")
		print("Disc Speed: ", speed)
		print("Final Distance: ", position.distance_to(starting_position) / 16, " feet")
		print("----------------------")

func throw():
	starting_position = position
	#var throw_direction = (get_global_mouse_position() - position).normalized()
	var throw_direction = Vector2(0,-1).normalized()
	linear_velocity = throw_direction * max_speed
	height = STARTING_HEIGHT
	grounded = false
	throw_ready = false
	
func rad_to_deg(rad):
	return rad / TAU * 360
