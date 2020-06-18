extends Node

const FILE_NAME = "user://save_data.json"

var load_game = false

var save_data = {
	"player_health": null,
	"carrots_in_field": null,
	"carrots_in_inventory": null,
	"quest_state": null
}

func save_game():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(save_data))
	file.close()


func load_game():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			save_data = data
		else:
			print("Data corrupted!")
	else:
		print("Couldn't find saved file! \nStarting new game...")
