extends Spatial

onready var activeItem = $HUD/ActiveItem
onready var itemQuantity = $HUD/ActiveItem/ItemQuantity
onready var healthBar = $HUD/HealthBar

var body_in_range
var item_quantity = 0
var carrot_icon = preload("res://Assets/2D/carrot_ic.png")

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("ping_body"):
		ping_item()
	if Input.is_action_just_pressed("use_item"):
		update_item(true)


func _on_PlayerRange_body_entered(body):
	if body.is_in_group("Carrot"):
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


func update_item(switch):
	if switch and healthBar.get_value() != 100 and item_quantity != 0:
		item_quantity -= 1
		healthBar.set_value(healthBar.get_value()+25)
	elif !switch:
		item_quantity += 1
	itemQuantity.set_text(str(item_quantity))
