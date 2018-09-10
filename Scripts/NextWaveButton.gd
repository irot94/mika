extends Button

onready var game_node = get_tree().get_root().get_node("Level0")

func _on_NextWaveButton_pressed():
	game_node.next_wave()
