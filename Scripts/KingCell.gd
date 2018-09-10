extends Area2D

onready var hp_counter = get_tree().get_root().get_node("Level0/GUI/MenusField/LifeCounter/CounterBox/Counter")
onready var points_counter = get_tree().get_root().get_node("Level0/GUI/MenusField/PointsCounter/CounterBox/Counter")
onready var game_node = get_tree().get_root().get_node("Level0")

func _on_PathEndTile_area_entered(area):
	if "Enemies" in area.get_groups():
		area.follow_path = false
		area.die(false)
		hp_counter.set_text(String(int(hp_counter.get_text()) - 1))
		game_node.add_to_points(-20)
		if int(hp_counter.get_text()) <= 0:
			_game_over()
			
func _game_over():
	get_tree().get_root().get_node("Level0/GUI/GameOverText").visible = true
	get_tree().paused = true