extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var total_time = 10

var id = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(self.time_left)
	$TextureProgress.value = time_left/total_time * 100
	
