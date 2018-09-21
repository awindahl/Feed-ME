extends Button

func _on_Start_pressed():
	get_tree().change_scene("res://Levels/Level Select.tscn")

func _on_Exit_pressed():
	get_tree().quit()