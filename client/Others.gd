extends Node2D
var coordinates = [];
var can_move = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var centre = Global.get_viewport_rect().size/2
	self.global_position = centre

func _input(event):
	if event is InputEventScreenDrag and can_move :
		self.global_position = event.position
		self.scale = Vector2(1.2, 1.2)
		#print(self.global_position)
		
	elif event is InputEventScreenTouch and !event.is_pressed():
		self.scale = Vector2(1, 1)
		coordinates = event.position
		Global.sendtoserver(coordinates, Global.PlayerName)
		
		#event.is
	#	self.scale = Vector2(1, 1)	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
