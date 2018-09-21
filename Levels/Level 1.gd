extends Node

func _ready():
	
	menumusic.stop()

func _process(delta):
	if $Player.size.x+$Player.maxCombo * 10 > run.highscore1:
		run.highscore1 = $Player.size.x+$Player.maxCombo * 10
	
	if $Pickups.get_child_count() == 0 and $Enemies.get_child_count() == 0:
		menumusic.play()
		run.lv1beat = true
		get_tree().change_scene("res://Levels/Level Select.tscn")
		
func _input(event):
	if event.is_action_released("ui_cancel"):
		menumusic.play()
		get_tree().change_scene("res://Levels/Level Select.tscn")