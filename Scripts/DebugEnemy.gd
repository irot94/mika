extends Area2D

onready var game_node = get_tree().get_root().get_node("Level0")
onready var points_counter = get_tree().get_root().get_node("Level0/GUI/MenusField/PointsCounter/CounterBox/Counter")
onready var temperature_indicator = get_tree().get_root().get_node("Level0/GUI/MenusField/TemperatureIndicator")
onready var water_indicator = get_tree().get_root().get_node("Level0/GUI/MenusField/WaterIndicator")

export var speed = 2

var follow_path = false
var max_hp = 50
var hp = max_hp
var bounty = 30
var pts_for_kill = 50
var bonus_points = 900
var killed_enemies = 0 # how many enemies killed
var is_dead = false

func _ready():
	$"HPBar".min_value = 0
	$"HPBar".max_value = max_hp
	$"HPBar".value = hp

func _process(delta):
	if follow_path:
		get_parent().offset += delta*speed*50

func _on_DebugEnemyTemplate_area_entered(area):
	if "Bullets" in area.get_groups():
		_get_shot(area)

func _get_shot(bullet):
		hp -= bullet.damage * (100 - abs(game_node.temperature_value))/100
		$"HPBar".value = hp
		#print("%s took hit for %s damage" % [self, bullet.damage * (100 - abs(game_node.temperature_value))/100.0])
		bullet._die()
		if hp <= 0:
			die(true)
			is_dead = true
		
func die(killed):
	if is_dead == false:
		hp = -1
		set_process(false)
		hide()
		if killed == true:
			killed_enemies = killed_enemies + 1
			test()
			game_node.add_to_money(bounty)
			game_node.add_to_points(points_for_kill())
			game_node.how_many_kills()
		yield( get_tree().create_timer(6), "timeout" )
		get_parent().get_parent().remove_child(get_parent())
		get_parent().queue_free()

func test():
	#print (game_node.get_temperature())
	#print (game_node.get_water())
	print (10)
	if game_node.WAVES.size() > 0: # w momencie klikniecia next wave, nie ma juz grupy 1
		if game_node.WAVES[0].get_group() == 2 and game_node.kills() == 3: #
			game_node.add_to_points(30)
		elif game_node.WAVES[0].get_group() == 3 and game_node.kills() == 9:
			game_node.add_to_points(60)
	elif game_node.kills() == 21:
		game_node.add_to_points(90)
		
func points_for_kill():
		var newpoints = 0
		if ((abs(game_node.temperature_value) + abs(game_node.water_value) > 0) and (abs(game_node.temperature_value) + abs(game_node.water_value) <= 30)):
			newpoints = 50
		elif ((abs(game_node.temperature_value) + abs(game_node.water_value) > 30) and (abs(game_node.temperature_value) + abs(game_node.water_value) <= 50)):
			newpoints = 35
		else:
			newpoints = 15
		return newpoints
