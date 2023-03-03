extends Node2D


# Declare graphics-related variables here. Examples:
var centre

# Declare time-related variables
var time
var timeformovement
var timeforjustification

# Coordinates
var coordinates
var botscoordinates

# Text Variables
var justificationtext = ""
var q1 = ""
var q2 = ""

# Import .json file
var querydict = []

# Preload scene for instancing
var scene = preload("res://Scenes/Player.tscn")
var others = preload("res://Scenes/Others.tscn")
var spawner

# Trial Information
var trialnumber

# Called when the node enters the scene tree for the first time.

func _ready():
	centre = Global.get_viewport_rect().size/2
	querydict = read_json_file("res://csvjson.json")
	trialnumber = 0
	set_trialdurations()
	align_stuff()
	start_trial()

## This functions when the game is started

func set_trialdurations():
	timeforjustification = 5.0
	timeformovement = 5.0
	
func read_json_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary
	
func align_stuff():
	$LineH.global_position.y = centre.y
	$LineV.global_position.x = centre.x

## Start game!

func start_trial():
	# Prepare the trial
	reset_position()
	display_new_questions()
	toggle_justification_visibility(false)
	
	# The trial should start now
	$Timer.id = "start_trial"
	start_timer(timeformovement) 
	$Player.can_move = true
	
	botscoordinates = Vector2(querydict[trialnumber].xcoordinates,
	 querydict[trialnumber].ycoordinates)
	spawn_others(querydict[trialnumber].timeonset*timeformovement,botscoordinates)
	spawn_others(querydict[trialnumber+1].timeonset*timeformovement,botscoordinates)
	
func display_new_questions():
	q1 = "[center]"+querydict[trialnumber].question1+"[/center]"
	q2 = "[center]"+querydict[trialnumber].question2+"[/center]"
	$Q1.set_bbcode(q1)
	$Q2.set_bbcode(q2)
	
func toggle_justification_visibility(boolean):
	$Justification.visible = boolean
	$Justification_text.visible = boolean
	
func spawn_others(spawn_time, botscoordinates):
	var timetospawn = Timer.new()
	add_child(timetospawn)
	timetospawn.wait_time = spawn_time
	timetospawn.one_shot = true
	timetospawn.start()
	timetospawn.connect("timeout", self, "_on_timetospawn_timeout")
	
func _on_timetospawn_timeout():
	spawner = others.instance()
	add_child(spawner)
	spawner.set_positions(botscoordinates)
	spawner.z_index = -1
	
func start_timer(trial_duration):
	$Timer.start(trial_duration)
	$Timer.total_time = trial_duration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_Timer_timeout():
	print("times up")
	$Player.can_move = false
	$Timer.stop()
	if $Timer.id == "justification":
		trialnumber = trialnumber + 1
		start_trial()
		remove_child(spawner)
		justificationtext = $Justification.text
		Global.sendtoserver(justificationtext, Global.PlayerName)
		
	elif $Timer.id == "start_trial":
		justification()

func justification():
	$Justification.visible = true
	$Justification_text.visible = true
	$Justification.text = ""
	$Timer.id = "justification"
	start_timer(timeforjustification)
	
func reset_position():
	$Player.global_position = centre


