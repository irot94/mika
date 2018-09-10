extends Node

class Wave:
	var enemy_count
	var enemy_type
	var spawn_timer
	var enemy_group
	func _init(enemy_count, enemy_type, spawn_timer, enemy_group):
		self.enemy_count = enemy_count
		self.enemy_type = enemy_type
		self.spawn_timer = spawn_timer
		self.enemy_group = enemy_group
	
	func get_group():
		return enemy_group


	
onready	var path_object = get_tree().get_root().get_node("Level0/PathContainer/Path")
onready var debug_enemy = get_tree().get_root().get_node("Level0/Templates/DebugEnemyTemplate")
onready var hp_counter = get_tree().get_root().get_node("Level0/GUI/MenusField/LifeCounter/CounterBox/Counter")
onready var money_counter = get_tree().get_root().get_node("Level0/GUI/MenusField/MoneyCounter/CounterBox/Counter")
onready var temperature_indicator = get_tree().get_root().get_node("Level0/GUI/MenusField/TemperatureIndicator")
onready var water_indicator = get_tree().get_root().get_node("Level0/GUI/MenusField/WaterIndicator")
onready var points_counter = get_tree().get_root().get_node("Level0/GUI/MenusField/PointsCounter/CounterBox/Counter")


var STARTING_MONEY = 100
var STARTING_HP = 10
var STARTING_POINTS = 0
var STARTING_KILLS = 1
var MAP_HEIGHT = 10
var MAP_WIDTH  = 8
var PATH_START = Vector2(96,-32)
var PATH_COORDS = [[1,0], 
                   [1,1], [2,1], [3,1], [4,1], [5,1], [6,1],
                                                      [6,2],
                                                      [6,3],
                   [6,4], [5,4], [4,4], [3,4], [2,4], [1,4],
                   [1,5],
                   [1,6], [2,6], [3,6],
                                 [3,7],
                                 [3,8], [4,8], [5,8]]

onready var WAVES = [Wave.new(3,  debug_enemy, 1, 1),
	 		 		 Wave.new(6,  debug_enemy, 1, 2),
	 				 Wave.new(12, debug_enemy, 1, 3)]
var selected_tile = Area2D
var initialized = false
var money = STARTING_MONEY
var points = STARTING_POINTS
var temperature_value = 0
var water_value = 0
var kills = STARTING_KILLS



func _ready():
	_generate_map()
	_initialize_counters()
	_initialize_indicators()
	
func next_wave():
	if WAVES.size() > 0:
		_spawn_enemies(path_object, WAVES[0])
		WAVES.remove(0)
	if WAVES.size() <= 0:
		get_tree().get_root().get_node("Level0/GUI/MenusField/NextWaveButton").disabled = true
		print("No more waves!")

func _generate_map():
	print("Generating map")

	path_object.get_curve().add_point(PATH_START)
	for i in range(MAP_WIDTH):
		for j in range(MAP_HEIGHT):
			if [i,j] in PATH_COORDS:
				_duplicate_tile(get_tree().get_root().get_node("Level0/Templates/PathTemplate"), 
								32 + 64 * i, 32 + 64 * j, 
								get_tree().get_root().get_node("Level0/PathContainer/"))
			else:
				_duplicate_tile(get_tree().get_root().get_node("Level0/Templates/TileTemplate"), 
								32 + 64 * i, 32 + 64 * j, 
								get_tree().get_root().get_node("Level0/TilesContainer/"))
								
	for path_coord in PATH_COORDS:
		path_object.get_curve().add_point(Vector2(32 + 64 * path_coord[0], 32 + 64 * path_coord[1]))
	
	
func _duplicate_tile(template_tile, position_x, position_y, target_node):
		var new_tile = template_tile.duplicate()
		new_tile.position = Vector2(position_x, position_y)
		target_node.add_child(new_tile)

func _initialize_counters():
	hp_counter.set_text(String(STARTING_HP))
	money_counter.set_text(String(STARTING_MONEY))
	points_counter.set_text(String(STARTING_POINTS))


func _initialize_indicators():
	_set_indicator(temperature_indicator, temperature_value)
	_set_indicator(water_indicator, water_value)
		
func change_temperature(delta):
	temperature_value += delta
	#TODO: change this to trigger game over?
	if temperature_value >= 100:
		temperature_value = 100
	if temperature_value <= -100:
		temperature_value = -100
	_set_indicator(temperature_indicator, temperature_value)
	
func change_water(delta):
	water_value += delta
	#TODO: change this to trigger game over?
	if water_value >= 100:
		water_value = 100
	if water_value <= -100:
		water_value = -100
	_set_indicator(water_indicator, water_value)
	
func _set_indicator(indicator_node, value):
	if value >= 0:
		indicator_node.get_node("MinusSign").value = 0
		indicator_node.get_node("PlusSign").value = value
	if value <= 0:
		indicator_node.get_node("MinusSign").value = abs(value)
		indicator_node.get_node("PlusSign").value = 0
	indicator_node.get_node("Value").text = String(value)

func _spawn_enemies(path, wave):
	for i in range(wave.enemy_count):
		var new_enemy = wave.enemy_type.duplicate()
		var new_enemy_path = path.get_node("PathFollow").duplicate()
		new_enemy.position = Vector2(0,0)
		new_enemy_path.add_child(new_enemy)
		path.add_child(new_enemy_path)
		new_enemy.follow_path = true
		yield( get_tree().create_timer(wave.spawn_timer), "timeout" )
	
func add_to_money(new_sum):
	money += new_sum
	money_counter.set_text(String(money))
	
func add_to_points(new_points):
	points += new_points
	points_counter.set_text(String(points))
	
func how_many_kills():
	kills = kills + 1
	#print (kills)
	
func kills():
	return kills
	
#func get_water():
#	return water_indicator.get_text()

#func get_temperature():
#	return temperature_indicator.get_text()
