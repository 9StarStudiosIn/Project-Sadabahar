extends StaticBody

onready var animation = $AnimationPlayer

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		if animation.is_playing():
			animation.stop(false)


func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		if !animation.is_playing():
			animation.play("NPC_track")
