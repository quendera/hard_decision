extends Node2D


# Declare member variables here. Examples:

var time
var centre
var timeformovement
var timeforjustification
var timeforbotjustification
var vector_array
var coordinates
var botscoordinates
var justificationtext = ""
var q1 = []
var q2 = []
var querydict = []
var trialnumber

var all_states = []

var rt = 0
var coord_1 = 0
var coord_2 = 0
var bot1
var botText

var bot_colors = [[230, 25, 75,255], [60, 180, 75,255], [255, 225, 25,255], [0, 130, 200,255]]

var player = preload("res://Game/Player.tscn")

var rand_color

# Called when the node enters the scene tree for the first time.

func _ready():
	#centre = Global.get_viewport_rect().size/2
	centre = Vector2(1380, 540)
	querydict = get_parent().read_json_file("res://hard_task1_bot1_behaviour.json")
	trialnumber = 0
	#get_parent().test()
	randomize()
	var idx = randi() % 4
	rand_color = bot_colors[idx]
	get_parent().send_bot_color(idx)
	set_trialdurations()
	start_trial()

func set_trialdurations():
	timeforjustification = 10.0
	timeformovement = 10.0
	timeforbotjustification = 10.0

func start_trial():
	if trialnumber == 2 :
		var file = File.new()
		file.open("user://response_INDP.json", File.WRITE)
		file.seek_end()
		file.store_line(to_json(all_states))
		get_tree().quit()
	else:
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
		botText = querydict[trialnumber].justification
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
	bot1.set_color(rand_color)
	
func start_timer(trial_duration):
	$Timer.start(trial_duration)
	$Timer.total_time = trial_duration

func _on_Timer_timeout():
	print("times up")
	$Timer.stop()
	if $Timer.id == "justification":
		$BotJustification.visible = true
		botjustification()
		save_state()
		## TODO Global.sendtoserver(justificationtext, Global.PlayerName)
	elif $Timer.id == "start_trial":
		justification()
		toggle_question_visibility(false)
	elif $Timer.id == "botjustification":
		$BotJustification.visible = false
		trialnumber = trialnumber + 1
		remove_child(bot1)
		get_parent().reset_player_state()
		start_trial()
	
func justification():
	$Timer.id = "justification"
	start_timer(timeforjustification)
	
func botjustification():
	$Timer.id = "botjustification"
	start_timer(timeforbotjustification)

func save_state():
	all_states.append(get_parent().player_states.duplicate(true))

	
func reset_position():
	$Player.global_position = centre

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

