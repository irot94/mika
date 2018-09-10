extends TextureButton

onready var game_node = get_tree().get_root().get_node("Level0")
onready var tower_node = get_tree().get_root().get_node("Level0/Templates/DebugTowerTemplate")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_SellButton_pressed():
	if game_node.selected_tile != null:
		if game_node.selected_tile.is_class("Area2D") and game_node.selected_tile.is_in_group("Towers"):
			print(game_node.selected_tile)
			game_node.add_to_money(int(tower_node.cost/2))
			game_node.selected_tile.covered_tile.show()
			game_node.selected_tile.covered_tile.set_process(true)
			game_node.selected_tile.get_parent().remove_child(game_node.selected_tile)
			game_node.selected_tile.queue_free()
			game_node.selected_tile = null
			game_node.change_temperature(-tower_node.temperature_delta)
			game_node.change_water(-tower_node.water_delta)
