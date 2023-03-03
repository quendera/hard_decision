extends Control

func _on_StartGame_pressed():
	$StartGame.hide()
	$WaitingUsers.visible = true
	Server.connect_to_server()
