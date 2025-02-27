extends Container

var rat : Object = null

func _ready():
	GlobalSignals.line_set_rat.connect(set_rat)



func _process(delta):
	pass

func set_rat(_rat : Object):
	if rat != null:
		return
	rat = _rat

func _on_ok_pressed():
	if rat == null or %LineEdit.get_text() == "":
		return
	rat.rat_name = %LineEdit.get_text()
	rat.set_physics_process(true)
	GlobalSignals.ok_pressed.emit(self, rat.rat_name)
	


func _on_no_pressed():
	if rat == null:
		return
	rat.set_physics_process(true)
	GlobalSignals.no_pressed.emit(self)
