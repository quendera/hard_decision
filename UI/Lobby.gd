extends Control

func _on_StartGame_pressed():
	Server.connect_to_server()
