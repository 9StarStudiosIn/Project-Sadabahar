extends ColorRect



func _on_StartGame_pressed():
	$ButtonClick.play()
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_LoadGame_pressed():
	$ButtonClick.play()
	GameManager.load_game = true
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_QuitGame_pressed():
	get_tree().quit()
