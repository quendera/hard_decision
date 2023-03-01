extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var can_move = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var centre = Global.get_viewport_rect().size/2
	self.global_position = centre


func _input(event):
	if event is InputEventScreenDrag and can_move :
		self.global_position = event.position
		print(self.global_position)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
