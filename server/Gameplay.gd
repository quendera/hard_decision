extends Node2D


# Declare member variables here. Examples:

var time
var centre
var timeformovement
var timeforjustification
var vector_array
var coordinates
var botscoordinates
var justificationtext = ""
var q1 = []
var q2 = []
var querydict = []
var trialnumber

var rt = 0
var coord_1 = 0
var coord_2 = 0
var bot1


var player = preload("res://Game/player.tscn")

# Called when the node enters the scene tree for the first time.

func _ready():
	#centre = Global.get_viewport_rect().size/2
	centre = Vector2(1380, 540)
	querydict = get_parent().read_json_file("res://hard_task1_bot1_behaviour.json")
	trialnumber = 0
	#get_parent().test()
	set_trialdurations()
	start_trial()

func set_trialdurations():
	timeforjustification = 10.0
	timeformovement = 10.0

func start_trial():
	#Server.send_update_question(querydict[trialnumber])
	q1 = "[color=blue]Question 1: [/color] \n" + querydict[trialnumber].prompt1
	q2 = "[color=red]Question 2: [/color] \n" + querydict[trialnumber].prompt2
	$Q1.set_bbcode(q1)
	$Q2.set_bbcode(q2)
	toggle_question_visibility(true)
	$Timer.id = "start_trial"
	start_timer(timeformovement)
	rt = querydict[trialnumber].rt
	coord_1 = 1380 + querydict[trialnumber].coord1 * 4
	coord_2 = 540 + querydict[trialnumber].coord2 * 4
	spawn_others(rt*timeformovement)

func toggle_question_visibility(boolean):
	$Q1.visible = boolean
	$Q2.visible = boolean
	
func spawn_others(spawn_time):
	print(spawn_time)
	var timetospawn = Timer.new()
	add_child(timetospawn)
	timetospawn.wait_time = spawn_time
	timetospawn.one_shot = true
	timetospawn.start()
	timetospawn.connect("timeout", self, "_on_timetospawn_timeout")
	
func _on_timetospawn_timeout():
	print("SPAWN")
	bot1 = player.instance()
	add_child(bot1)
	bot1.update_coordinate(coord_1, coord_2)
	bot1.set_color([255,0,0,1])
	
func start_timer(trial_duration):
	$Timer.start(trial_duration)
	$Timer.total_time = trial_duration

func _on_Timer_timeout():
	print("times up")
	$Timer.stop()
	if $Timer.id == "justification":
		trialnumber = trialnumber + 1
		start_trial()
		#remove_child(spawner)
		justificationtext = $Justification.text
		
	elif $Timer.id == "start_trial":
		trialnumber = trialnumber + 1
		start_trial()
		remove_child(bot1)
		#justification()

func justification():
	$Justification.visible = true
	$Justification_text.visible = true
	$Justification.text = ""
	$Timer.id = "justification"
	start_timer(timeforjustification)
	
	
func reset_position():
	$Player.global_position = centre
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

