extends Control


func _input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed):
		get_tree().change_scene("res://Game.tscn")
		