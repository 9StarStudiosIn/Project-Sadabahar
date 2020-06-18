extends Spatial

onready var activeItem = $HUD/ActiveItem
onready var itemQuantity = $HUD/ActiveItem/ItemQuantity
onready var healthBar = $HUD/HealthBar
onready var dialog = $DialogBox/Popup
onready var dialogSpeech = $DialogBox/Popup/DialogBackground/DialogText

var body_in_range
var item_quantity = 0
var carrot_icon = preload("res://Assets/2D/carrot_ic.png")
var quest_state
var popup_visibility = false

enum QuestState{
	DISCOVER_QUEST,
	ACCEPT_QUEST,
	END_QUEST
}

func _ready():
	dialog.visible = false
	$PauseScreen/ColorRect.visible = false
	quest_state = QuestState.DISCOVER_QUEST
	if GameManager.load_game:
		GameManager.load_game()
		if GameManager.save_data["player_health"] != null:
			read_saved_file()


func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().change_scene("res://Scenes/StartGameScreen.tscn")
	if Input.is_action_just_pressed("pause"):
		GameManager.save_data["player_health"] = $HUD/HealthBar.get_value()
		GameManager.save_data["carrots_in_field"] = get_tree().get_nodes_in_group("Carrot").size()
		GameManager.save_data["carrots_in_inventory"] = item_quantity
		GameManager.save_data["quest_state"] = quest_state
		get_tree().paused = true
		$PauseScreen/ColorRect.visible = true
	if Input.is_action_just_pressed("ping_body"):
		ping_item()
	if Input.is_action_just_pressed("use_item"):
		$Crunch.play()
		update_item(true)
	if Input.is_action_just_pressed("reply") and popup_visibility:
		dialog.visible = false
		popup_visibility = false


func _on_PlayerRange_body_entered(body):
	body_in_range = body


func _on_PlayerRange_body_exited(body):
	body_in_range = null


func ping_item():
	if body_in_range != null:
		if body_in_range.is_in_group("Carrot"):
			body_in_range.queue_free()
			if item_quantity == 0:
				activeItem.set_texture(carrot_icon)
			$Dig.play()
			update_item(false)
		elif body_in_range.is_in_group("NPC"):
			chat()


func update_item(switch):
	if switch and healthBar.get_value() != 100 and item_quantity != 0:
		item_quantity -= 1
		healthBar.set_value(healthBar.get_value()+25)
	elif !switch:
		item_quantity += 1
	itemQuantity.set_text(str(item_quantity))


func chat():
	dialog.popup()
	popup_visibility = true
	match quest_state:
		QuestState.DISCOVER_QUEST:
			dialogSpeech.set_text("Hey! Can you please get me a carrot?")
			quest_state = QuestState.ACCEPT_QUEST
		QuestState.ACCEPT_QUEST:
			if item_quantity == 0:
				dialogSpeech.set_text("Found any? I'm really hungry.")
			else:
				dialogSpeech.set_text("Thanks! Ahhh that's the stuff...")
				quest_state = QuestState.END_QUEST
				update_item(true)
				healthBar.set_value(healthBar.get_value()-25)
		QuestState.END_QUEST:
			dialogSpeech.set_text("Thanks a lot for helping me today!")


func read_saved_file():
	healthBar.value = GameManager.save_data["player_health"]
	quest_state = GameManager.save_data["quest_state"]
	quest_state = int(quest_state)
	if GameManager.save_data["carrots_in_field"] != 3:
		activeItem.set_texture(carrot_icon)
		item_quantity = GameManager.save_data["carrots_in_inventory"]
		itemQuantity.set_text(str(item_quantity))
		match int(GameManager.save_data["carrots_in_field"]):
			0:
				$Mud/Carrot.queue_free()
				$Mud/Carrot2.queue_free()
				$Mud/Carrot3.queue_free()
			1:
				$Mud/Carrot.queue_free()
				$Mud/Carrot2.queue_free()
			2:
				$Mud/Carrot.queue_free()
			3:
				pass


func _on_ResumeButton_pressed():
	get_tree().paused = false
	$PauseScreen/ColorRect.visible = false


func _on_SaveButton_pressed():
	GameManager.save_data["player_health"] = $HUD/HealthBar.get_value()
	GameManager.save_data["carrots_in_field"] = get_tree().get_nodes_in_group("Carrot").size()
	GameManager.save_data["carrots_in_inventory"] = item_quantity
	GameManager.save_data["quest_state"] = quest_state
	GameManager.save_game()
	get_tree().paused = false
	$PauseScreen/ColorRect.visible = false
