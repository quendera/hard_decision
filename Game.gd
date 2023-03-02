extends Node2D


# Declare member variables here. Examples:
var time
var centre
var timeformovement
var timeforjustification
var PlayerName = "test"
var scene = preload("res://Scenes/Player.tscn")


# Called when the node enters the scene tree for the first time.

func _ready():
	print(PlayerName)
	centre = Global.get_viewport_rect().size/2
	align_stuff()
	start_trial()

#func make_player(name):
#	var instance = scene.instance()
#	add_child(instance)

func align_stuff():
	$LineH.global_position.y = centre.y
	$LineV.global_position.x = centre.x

func start_trial():
	timeformovement = 5
	$Q1.set_bbcode("[center]Trump or Obama[/center]")
	$Q2.set_bbcode("[center]Orange or Blue[/center]")
	$Justification.visible = false
	$Justification_text.visible = false
	$Player.can_move = true
	$Timer.id = "start_trial"
	start_timer(timeformovement)
	reset_position()

func start_timer(trial_duration):
	$Timer.start(trial_duration)
	$Timer.total_time = trial_duration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#print($Icon.global_position)

func _on_Timer_timeout():
	print("times up")
	$Player.can_move = false
	$Timer.stop()
	if $Timer.id == "justification":
		start_trial()
	elif $Timer.id == "start_trial":
		justification()

func justification():
	timeforjustification = 5
	$Justification.visible = true
	$Justification_text.visible = true
	$Justification.text = ""
	$Timer.id = "justification"
	start_timer(timeforjustification)
	
func reset_position():
	$Player.global_position = centre

	
