extends RigidBody2D

@export var MIN_AIR_FRIC_COEF: float = 0.06
@export var MAX_AIR_FRIC_COEF: float = 0.10
@export var MAX_SPEED: float = 1150
@export var MIN_SPEED: float = 1000
@export var GLIDE_COEF: float = 8
@export var GRAVITY: float = 35
@export var STARTING_HEIGHT: float = 6.0
@export var SKIP_VERTICAL_SPEED_COEF: float = 0.7
@export var MAX_SKIP_SPEED_COEF: float = .75
@export var MIN_SKIP_SPEED_COEF: float = .4
@export var MIN_SKIP_SPEED: int = 10

@export var speed: int = 13
@export var glide: int = 5
@export var turn: int = -1
@export var fade: int = 3

var height = 0
var vertical_velocity = 0
var grounded = true
var max_h = 0
var skip_speed_coef = (speed / 14.5) * (MAX_SKIP_SPEED_COEF - MIN_SKIP_SPEED_COEF) + MIN_SKIP_SPEED_COEF
var throw_ready = false
var max_speed = 0
var neg = 1 #REMOVE TODO

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
		print("Final Distance: ", position.x / 16, " feet")
		print("----------------------")
		
		#neg *= -1
		#speed -= 4

func throw():
	#var throw_direction = (get_global_mouse_position() - position).normalized()
	var throw_direction = Vector2(neg * 1,0)
	linear_velocity = throw_direction * ((speed / 14.5) * (MAX_SPEED - MIN_SPEED) + MIN_SPEED)
	max_speed = linear_velocity.length()
	height = STARTING_HEIGHT
	grounded = false
	throw_ready = false
