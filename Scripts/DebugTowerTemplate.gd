extends Area2D

onready var bullet_template = get_tree().get_root().get_node("Level0/Templates/BulletTemplate")
onready var game_node = get_tree().get_root().get_node("Level0")
onready var path_follow_node = get_tree().get_root().get_node("Level0/PathContainer/Path/PathFollow")

export var reload_time = 1
var tower_damage = 20
var cost = 55
var temperature_delta = 20
var water_delta = -15

var is_selected = false
var is_shooting = false
var targets = []
var covered_tile

func _ready():
	set_process(false)

func _process(delta):
	if !is_shooting and targets.size() > 0:
		#print(targets)
		is_shooting = true
		_shoot_and_reload(targets[0])

func _on_DebugTowerTemplate_area_entered(area):
	if "Enemies" in area.get_groups():
		targets.append(area)
		targets.sort_custom(TargetsSorter, "sort")

func _on_DebugTowerTemplate_area_exited(area):
	if "Enemies" in area.get_groups():
		targets.erase(area)
		targets.sort_custom(TargetsSorter, "sort")
	
class TargetsSorter:
	static func sort(a, b):
		if a.get_parent().offset > b.get_parent().offset:
			return true
		return false
	
func _shoot_and_reload(enemy):
	var enemy_parent_node = enemy.get_parent()
	if enemy in targets:
		if enemy.hp > 0:
			_shoot(enemy_parent_node.position)
			#print(reload_time * (100 - abs(game_node.water_value))/100.0)
			yield( get_tree().create_timer(reload_time * (100 + abs(game_node.water_value))/100.0), "timeout" )
		else:
			targets.erase(enemy)
	is_shooting = false

func _shoot(enemy_position):
	#print("[%s] enemy: spotted at: %s" % [self, enemy_position])
	var new_bullet = bullet_template.duplicate()
	var bullet_path = Path2D.new()
	var bullet_path_follow = PathFollow2D.new()
	bullet_path.position = Vector2(0,0)
	bullet_path_follow.position = Vector2(0,0)
	bullet_path_follow.loop = false
	new_bullet.position = Vector2(0,0)
	
	get_tree().get_root().get_node("Level0/BulletsContainer").add_child(bullet_path)
	bullet_path.add_child(bullet_path_follow)
	bullet_path_follow.add_child(new_bullet)

	#print("Adding bullet path start: %s" % position)
	bullet_path.get_curve().add_point(position)
	#print("Adding bullet path end: %s" % enemy_position)
	bullet_path.get_curve().add_point(enemy_position)

	new_bullet.damage = tower_damage
	new_bullet.follow_path = true
	new_bullet.set_process(true)


func _on_DebugTowerTemplate_input_event(viewport, event, shape_idx):
	if event is InputEventMouse and Input.is_mouse_button_pressed(BUTTON_LEFT) and shape_idx == 1:
		if is_selected:
			print("deselected %s" % game_node.selected_tile)
			$"SelectedSprite".visible = false
			is_selected = false
			game_node.selected_tile = null
		else:
			for sellButton in get_tree().get_nodes_in_group("SellButtons"):
				sellButton.disabled = false
			for buyButton in get_tree().get_nodes_in_group("BuyButtons"):
				buyButton.disabled = true	

			if game_node.selected_tile != null:
				game_node.selected_tile.get_node("SelectedSprite").visible = false
				print("deselected %s" % game_node.selected_tile)
				game_node.selected_tile.is_selected = false

			$"SelectedSprite".visible = true
			is_selected = true
			game_node.selected_tile = self
			print("selected %s" % game_node.selected_tile)


func _on_ClickableArea_mouse_entered():
	get_node("ClickableArea/RangeSprite").visible = true

func _on_ClickableArea_mouse_exited():
	get_node("ClickableArea/RangeSprite").visible = false
