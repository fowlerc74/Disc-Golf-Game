extends Sprite2D

@export var DISC_HEIGHT_COEF: float = 1.5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offset.y = -1 * DISC_HEIGHT_COEF * get_parent().height
	
