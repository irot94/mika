extends ColorRect

onready var game_node = get_tree().get_root().get_node("Level0")
var future_tower_range_sprite
var future_tower_sprite
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_DebugTower_mouse_entered():
	if game_node.initialized:
		if game_node.selected_tile != null:
			future_tower_range_sprite = Sprite.new()
			future_tower_range_sprite.texture = load("res://Sprites/TowerRangeRadius150ps.png")
			future_tower_range_sprite.z_index = 3
			future_tower_sprite = Sprite.new()
			future_tower_sprite.texture = load("res://Sprites/debugTower.png")
			future_tower_sprite.z_index = 3
			game_node.selected_tile.add_child(future_tower_range_sprite)
			game_node.selected_tile.add_child(future_tower_sprite)


func _on_DebugTower_mouse_exited():
	if game_node.initialized:
		if game_node.selected_tile != null:
			game_node.selected_tile.remove_child(future_tower_range_sprite)
			game_node.selected_tile.remove_child(future_tower_sprite)
