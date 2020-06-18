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
	quest_state = QuestState.DISCOVER_QUEST


func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("ping_body"):
		ping_item()
	if Input.is_action_just_pressed("use_item"):
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
