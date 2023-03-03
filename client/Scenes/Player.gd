extends Node2D
var coordinates = [];
var can_move = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var centre = Global.get_viewport_rect().size/2
	#var centre = Vector2(1380, 540)
	self.global_position = centre

func _input(event):
	if event is InputEventScreenDrag and can_move:
		self.global_position = event.position
		self.scale = Vector2(1.2, 1.2)
		#print(self.global_position)
		# 100 980, 940
	elif event is InputEventScreenTouch and !event.is_pressed():
		self.scale = Vector2(1, 1)
		coordinates = event.position
		send_player_state()
		#Global.sendtoserver(coordinates, Global.PlayerName)
		
		#event.is
	#	self.scale = Vector2(1, 1)	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
var pos
func _process(_delta):
	if self.global_position.x > 100 and self.global_position.x < 980 and self.global_position.y > 940 and self.global_position.y < 1820:
		pos = global_position
	else:
		self.global_position = pos
		
	

func send_player_state():
	var player_state = {
		"P": get_global_position(),
	}
	Server.send_player_state(player_state)
