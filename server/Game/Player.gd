extends Node2D
# Called when the node enters the scene tree for the first time.

func _ready():
	var centre = Vector2(1380, 540)
	self.global_position = centre
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func update_coordinate(x,y):
	self.global_position = Vector2(x,y)
	
func set_color(color):
	print($Polygon2D.color)
	$Polygon2D.color = color
