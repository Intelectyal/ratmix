extends Node2D

var index 
var erase : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn()
	pass # Replace with function body.

func spawn():
	position = Vector2(randi_range(0,1920),randi_range(0,1080))
	var i : int = randi_range(0,2)
	match i:
		0:
			$Sprite2D.texture = ResourceLoader.load("res://art/object2/mess0.png")
		1:
			$Sprite2D.texture = ResourceLoader.load("res://art/object2/mess1.png")
		2:
			$Sprite2D.texture = ResourceLoader.load("res://art/object2/mess2.png")	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_mouse_entered():
	if GlobalFuncNVar.Brush == true:
		erase += 1 
		if erase >= 3:
			queue_free()
