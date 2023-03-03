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
var q1_top = ""
var q2_top = ""
var q1_bot = ""
var q2_bot = ""
var querydict = []
var trialnumber

# Called when the node enters the scene tree for the first time.

func _ready():
	#centre = Global.get_viewport_rect().size/2
	centre = Vector2(1380, 540)
	querydict = read_json_file("res://csvjson.json")
	trialnumber = 0
	start_trial()
	# align_stuff()


func start_trial():
	#Server.send_update_question(querydict[trialnumber])
	q1 = querydict[trialnumber].question1.split("or")
	q2 = querydict[trialnumber].question2.split("or")
	q1_top = "[center]"+q1[0]+"[/center]"
	q1_bot = "[center]"+q1[1]+"[/center]"
	q2_top = "[center]"+q2[0]+"[/center]"
	q2_bot = "[center]"+q2[1]+"[/center]"
	$Q1_top.set_bbcode(q1_top)
	$Q1_bot.set_bbcode(q1_bot)
	$Q2_right.set_bbcode(q2_top)
	$Q2_left.set_bbcode(q2_bot)

func read_json_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



