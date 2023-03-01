extends Node2D


# Declare member variables here. Examples:
var time
var PlayerName = "test"


var scene = preload("res://Scenes/Player.tscn")


# Called when the node enters the scene tree for the first time.

func _ready():
	print(PlayerName)
	start_trial()
#	make_player(PlayerName)


#func make_player(name):
#	var instance = scene.instance()
#	add_child(instance)


func start_trial():
	var trial_duration = 5
	$Q1.text = "Trump or Obama"
	$Q2.text = "Orange or Purple"
	$Justification.visible = false
	$Justification_text.visible = false
	$Player.can_move = true
	$Timer.id = "start_trial"
	start_timer(trial_duration)
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
	$Justification.visible = true
	$Justification_text.visible = true
	$Justification.text = ""
	$Timer.id = "justification"
	start_timer(3)
	
func reset_position():
	$Player.global_position = Global.get_viewport_rect().size/2
