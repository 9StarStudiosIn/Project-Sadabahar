extends ColorRect



func _on_StartGame_pressed():
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_LoadGame_pressed():
	GameManager.load_game = true
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_QuitGame_pressed():
	get_tree().quit()
