extends CanvasLayer

onready var player = get_parent().get_node("Player")

func _process(delta):
	$combo.text = "combo: " + var2str(player.combo)
	$health.text = "health: " + var2str(player.health)