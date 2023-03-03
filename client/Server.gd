extends Node
var q1 = []
var q2 = []
var q1_top = ""
var q2_top = ""
var q1_bot = ""
var q2_bot = ""
remote var querydict = []

var client

# Enable dev mode by launching the game with -dev flag or "DEV=true" env variable.
var DEV = OS.get_environment("DEV") or Array(OS.get_cmdline_args()).has("-dev") or true
# save it in a global variable so that Enemy could take a name from this list
# to display it above their healthbar
var player_list = [] 
#var url = "http://95.179.179.188/hard_decision/server/hard_decision_server_2.html"
var url = "ws://127.0.0.1:7070" #Local
#var url = "ws://192.168.1.102:7070" #LAN

func _ready():
	pass
	# Start the game automatically, without going through the lobby
	#if DEV: connect_to_server()


func connect_to_server():
	client = WebSocketClient.new()
	
	# Connect to server, use WSS
	#var url = "http://95.179.179.188/hard_decision/server/hard_decision_server_2.html"
	#var url = "ws://127.0.0.1:7070"
	#var url = "ws://169.254.184.206:7070"
	# Connect without WSS
	# url = "ws://178.62.117.12:6969"

	print("Connecting to server: ", url)
	var error = client.connect_to_url(url, PoolStringArray(), true)

	# Connect signals
	client.connect("connection_failed", self, "_connection_failed")
	client.connect("connection_succeeded", self, "_connection_succeeded")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	#net.connect("network_peer_connected", self, "_network_peer_connected")
	#net.connect("network_peer_disconnected", self, "_network_peer_disconnected")
	#net.connect("server_disconnected", self, "_server_disconnected")

	get_tree().set_network_peer(client)


func _process(delta):
	if not client: return
	if (client.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED || client.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTING):
		client.poll()

func disconnect_from_server(): 
	# client.close_connection()
	client.disconnect_from_host()
	get_tree().set_network_peer(null)
	# Disconnet signals
	client.disconnect("connection_failed", self, "_connection_failed")
	get_tree().disconnect("connected_to_server", self, "_connected_to_server")

func _connection_failed():
	# TODO - this never runs for some reason??
	print("Can't connect to server!")
	get_tree().change_scene("res://UI/Lobby.tscn")

func _connected_to_server():
	print("Successfully connected to server")
	var player_data = {}
	# temporarily use ids instead of names
	player_data = { "player_name": str(get_tree().get_network_unique_id()) }
	rpc_id(1, "broadcast_player_list", player_data)

remote func update_player_list(players):
	# When a new player joins, server updates the players variable, and then
	# tells everyone to run this function
	#player_list = players
	#get_node("/root/World").receive_player_info(player_list)
	pass

remote func despawn_enemy(enemy_id):
	# Cant set it on_ready, becasue it disappears when I reload scene
	get_node("/root/World").despawn_enemy(enemy_id)

func send_player_state(player_state):
	print("Sending states")
	rpc_unreliable_id(1, "receive_player_state", player_state)

remote func receive_world_state(world_state):
	var world = get_node_or_null("/root/World")
	if not world: return
	world.receive_world_state(world_state)
	# print("Server Time: ", print_time(world_state["T"]), "\tClient Time: ", print_time(client_clock))

remote func start_game():
	print("START GAME")
	get_tree().change_scene("res://Scenes/Game.tscn")

remote func update_question(remote_querydict):
	print("HI")
	print(remote_querydict)










