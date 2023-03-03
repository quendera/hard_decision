extends Node

var player_list = {} 
var player_states = {}
var world_state = {}
var querydict = []
var playerColor = [[255,127,15,255], [43,160,43,255], [148,103,189,255], [140,86,76,255]]
#var playerColor = ["crimson"]


#rgba(214,39,39,255)
#rgba(31,119,180,255)
var game = preload("res://Game/Game.tscn")
var player = preload("res://Game/Player.tscn")

var PROD = OS.get_environment("PROD") or Array(OS.get_cmdline_args()).has("-prod")
var server = WebSocketServer.new() # NetworkedMultiplayerENet.new()
const PORT = 7070
const MAX_PLAYERS = 4

func _ready():
	start_server()
	
func start_server():
	if PROD:
		print("Using SSL")
		server.private_key = load("res://HTTPSKeys/privkey.key")
		server.ssl_certificate = load("res://HTTPSKeys/certificate.crt")

	server.listen(PORT, PoolStringArray(), true)
	get_tree().set_network_peer(server)
	print("Server Started")
	# When clients connect/disconnect these signals fire
	server.connect("peer_connected", self, "_peer_connected")
	server.connect("peer_disconnected", self, "_peer_disconnected")

func _process(delta):
	if server.is_listening(): 
		server.poll()

func _peer_connected(player_id):
	print("User " + str(player_id) + " connected")

func _peer_disconnected(player_id):
	print("User " + str(player_id) + " disconnected")
	if player_list.has(player_id):
		player_list.erase(player_id)
	if player_states.has(player_id):
		player_states.erase(player_id)
		#remove_child()
		#rpc_id(0, "update_player_list", player_list)

remote func broadcast_player_list(player_data):
	# Once player is _connected_to_server, they'll send me their info(name)
	# so that I can send it to everyone and update their player lists
	var player_id = get_tree().get_rpc_sender_id() 
	player_data["join_order"] = player_list.size()
	player_list[player_id] = player_data
	print("Broadcast player list ", player_list)
	#rpc_id(0, "update_player_list", player_list)
	if player_data["join_order"]  % 2 == 0:
		rset_id(player_id, "show_botjustification", true)

# separate variable containing only their names, so that I don't have to
# send player's name along with his state every frame


func reset_player_state():
	for player_id in world_state.keys(): 
		world_state[player_id].update_coordinate(1380, 540)
		
remote func receive_player_state(player_state):
	var player_id = get_tree().get_rpc_sender_id() 
	# If packets arrived out of order, and the new player_state is older than the old one, we ignore it
	if player_states.has(player_id):
		player_states[player_id] = player_state
	else:
		player_states[player_id] = player_state
		var newplayer = player.instance()
		world_state[player_id] = newplayer
		add_child(world_state[player_id])
	var coordinates = player_states[player_id]['P']
	var dx = coordinates[0] - 540
	var dy = coordinates[1] - 1380
	world_state[player_id].update_coordinate(1380 + dx, 540+dy)
	print(player_list[player_id]["join_order"])
	world_state[player_id].set_color(playerColor[player_list[player_id]["join_order"]])

func _on_tick_rate_timeout():
	pass

func _on_startgame_pressed():
	querydict = read_json_file("res://hard_task1_bot1_behaviour.json")
	print("Start clicked")
	for player_id in player_list.keys(): 
		print(player_id)
		rset_id(player_id, "querydict", querydict)
		rpc_id(player_id, "start_game")
	$Control.visible = false
	var instance = game.instance()
	add_child(instance)

func read_json_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary
#func send_update_question(querydict):
#	pass


