extends Area2D

export var speed = 30
var damage = 0

var follow_path = false

func _ready():
	set_process(false)

func _process(delta):
	if follow_path:
		get_parent().offset += delta*speed*50

func _die():
	set_process(false)
	hide()
	get_parent().remove_child(self)
	queue_free()