extends Area2D

var is_selected = false
onready var game_node = get_tree().get_root().get_node("Level0")

func _ready():
	pass

func _on_Cell0_mouse_entered():
	$"HoverSprite".visible = true

func _on_Cell0_mouse_exited():
	$"HoverSprite".visible = false

func _on_Cell0_input_event(viewport, event, shape_idx):
	if event is InputEventMouse and Input.is_mouse_button_pressed(BUTTON_LEFT):
		if is_selected:
			print("deselected %s" % game_node.selected_tile)
			$"SelectedSprite".visible = false
			is_selected = false
			game_node.selected_tile = null
		else:
			for sellButton in get_tree().get_nodes_in_group("SellButtons"):
				sellButton.disabled = true
			for buyButton in get_tree().get_nodes_in_group("BuyButtons"):
				buyButton.disabled = false	
			if game_node.initialized:
				if game_node.selected_tile != null:
					game_node.selected_tile.get_node("SelectedSprite").visible = false
					print("deselected %s" % game_node.selected_tile)
					game_node.selected_tile.is_selected = false
			else:
				game_node.initialized = true
			$"SelectedSprite".visible = true
			is_selected = true
			game_node.selected_tile = self
			print("selected %s" % game_node.selected_tile)
