extends Container


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ok_pressed():
	GlobalSignals.ok_pressed.emit(self)


func _on_no_pressed():
	GlobalSignals.no_pressed.emit(self)
