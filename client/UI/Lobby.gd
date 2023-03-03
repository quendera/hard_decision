extends Control

func _on_StartGame_pressed():
	$StartGame.hide()
	$WaitingUsers.visible = true
	Server.connect_to_server()


func _on_TextEdit_text_changed():
	Server.url = $TextEdit.text
	print(Server.url)

