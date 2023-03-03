extends Node2D


# Declare graphics-related variables here. Examples:
var centre

# Declare time-related variables
var time
var timeformovement
var timeforjustification
var timeforbotjustification

# Coordinates
var coordinates
var botscoordinates

# Text Variables
var justificationtext = ""
var q1 = []
var q2 = []
var querydict = []

# Preload scene for instancing
var scene = preload("res://Scenes/Player.tscn")
var others = preload("res://Scenes/Others.tscn")
var spawner

# Trial Information
var trialnumber

# Called when the node enters the scene tree for the first time.

func _ready():
	print(Global.PlayerName)
	#centre = Global.get_viewport_rect().size/2
	centre = Vector2($ColorRect.rect_global_position.x + 440,
	$ColorRect.rect_global_position.y + 440)
	#querydict = read_json_file("res://csvjson.json")
	trialnumber = 0
	set_trialdurations()
	# align_stuff()
	start_trial()

## This functions when the game is started

func set_trialdurations():
	timeforjustification = 10.0
	timeformovement = 10.0
	timeforbotjustification = 10.0
	
func read_json_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary
	
#func align_stuff():
#	$LineH.global_position.y = centre.y
#	$LineV.global_position.x = 1380

## Start game!

func start_trial():
	# Prepare the trial
	reset_position()
	querydict = Server.querydict
	q1 = "[color=blue]Question 1: [/color]" + querydict[trialnumber].prompt1
	q2 = "[color=red]Question 2: [/color]" + querydict[trialnumber].prompt2
	$Q1.set_bbcode(q1)
	$Q2.set_bbcode(q2)
	toggle_question_visibility(true)
	$Justification.visible = false
	$Justification_text.visible = false
	$BotJustifications.visible = false
	$Player.can_move = true
	$Timer.id = "start_trial"
	start_timer(timeformovement) 

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

func toggle_question_visibility(boolean):
	$Q1.visible = boolean
	$Q2.visible = boolean
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_Timer_timeout():
	print("times up")
	$Player.can_move = false
	$Timer.stop()
	if $Timer.id == "justification":
		remove_child(spawner)
		justificationtext = $Justification.text
		botjustification()
		Global.sendtoserver(justificationtext, Global.PlayerName)
		
		
	elif $Timer.id == "start_trial":
		justification()
		toggle_question_visibility(false)
		
	elif $Timer.id == "botjustification":
		$BotJustifications.visible = false
		trialnumber = trialnumber + 1
		start_trial()
	
func justification():
	$Justification.visible = true
	$Justification_text.visible = true
	$Justification.text = ""
	$Timer.id = "justification"
	start_timer(timeforjustification)

func botjustification():
	$Justification.visible = false
	$Justification_text.visible = false
	if Server.show_botjustification:
		$BotJustifications.visible = true

	$Timer.id = "botjustification"
	send_player_justification()
	start_timer(timeforbotjustification)

func reset_position():
	$Player.global_position = centre

func send_player_justification():
	var player_justification = {
		"J": $Justification.text,
	}
	Server.send_player_justification(player_justification)
