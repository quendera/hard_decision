extends Node2D
var coordinates = Vector2();

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_positions(coordinates):
	print(coordinates)
	self.global_position = coordinates
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
