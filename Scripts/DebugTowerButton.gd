extends TextureButton

onready var game_node = get_tree().get_root().get_node("Level0")
onready var tower_node = get_tree().get_root().get_node("Level0/Templates/DebugTowerTemplate")


func _ready():
	pass
	
#func _process(delta):
	#pass

func _on_BuyButton_pressed():
	if game_node.selected_tile != null:
		if game_node.selected_tile.is_class("Area2D") and !game_node.selected_tile.is_in_group("Towers"):
			if game_node.money >= tower_node.cost:
				game_node.add_to_money(-tower_node.cost)
				game_node.selected_tile.set_process(false)
				game_node.selected_tile.hide()
				var new_tower = tower_node.duplicate()
				new_tower.covered_tile = game_node.selected_tile
				new_tower.position = game_node.selected_tile.position
				game_node.selected_tile.get_parent().add_child(new_tower)
				new_tower.set_process(true)
				game_node.change_temperature(tower_node.temperature_delta)
				game_node.change_water(tower_node.water_delta)
			else:
				print("Not enough money! Need %s to build this tower!" % tower_node.cost)


func _on_BuyButton_focus_entered():
	print("FOCUS")
