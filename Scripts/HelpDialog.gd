extends AcceptDialog

func _ready():
	dialog_text = \
	"""Welcome to mikaTD. 
	Your goal is to protect the king from incoming enemies.

	To build a tower click on the tile then find the tower you are interested and click 'BUY' button.
	You can sell the towers for half of their value - click the tower and the click 'SELL' button
	
	When you build the towers, you alter the indicators.
	You need to keep them arround ZERO for maximum firing power and number of points you get.
	The farther they are from zero, the weaker the towers become and the less points gain.
		Temperature affect tower's damage.
		Water affect tower's reload time.
	
	Building FirstTower will result in following effects:
		- Gold -60
		- Temperature +20
		- Water -15
		
	To send enemy wave click the 'NEXT WAVE' button.
	To display this message and pause the game click 'HELP' button.
	
	When you kill one enemie you can get 50, 35 or 15 points - all depends on difference between Water and Temperature value. 
	Smaller difference - better for you. Also you can get bonus points when you kill all enemies in one wave.
	However if enemie reches the king, you loose not only life, but points as well.
	
	Killing enemies provides you with gold which can be used to buy more towers.
	If you fail to kill an enemy and he reaches the king, then your life total will be decreased.
	You will lose the game when you have 0 lives.
	
	Have fun!
	
	"""
	popup()

func _on_HelpButton_pressed():
	popup()
	get_tree().paused = true


func _on_HelpDialog_confirmed():
	get_tree().paused = false
