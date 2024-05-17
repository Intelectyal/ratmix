extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalFuncNVar.Wheel_buy.connect(Wheel_update)
	GlobalFuncNVar.Bush_buy.connect(Bush_update)
	GlobalFuncNVar.Tramp_buy.connect(Tramp_update)
	GlobalFuncNVar.Tube_buy.connect(Tube_update)
	GlobalFuncNVar.House_buy.connect(House_update)
	GlobalFuncNVar.Bowl_buy.connect(Bowl_update)
	GlobalFuncNVar.obj_start_animation.connect(start_animation)
	GlobalFuncNVar.obj_stop_animation.connect(stop_animation)
	GlobalFuncNVar.tramp_frame.connect(Tramp_frame)
	GlobalFuncNVar.food_in_bowl.connect(Bowl_food)
	%Wheel.pause()
	%Bush.pause()
	%Tramp.pause()
	%Tube.pause()

	
func start_animation(name):
	match(name):
		"Wheel":
			%Wheel.play()
		"Bush":
			%Bush.play()
		"Tramp":
			#%Tramp.play()
			pass
		"Tube":
			%Tube.play()	
		_:
			pass	
			
func stop_animation(name):
	match(name):
		"Wheel":
			%Wheel.pause()
		"Bush":
			%Bush.pause()
		"Tramp":
			#%Tramp.play()
			pass
		"Tube":
			%Tube.pause()	
		_:
			pass	

func Wheel_update():
	%Wheel.visible = true
	GlobalFuncNVar.objs_list["Wheel"] = true
func Bush_update():
	%Bush.visible = true
	GlobalFuncNVar.objs_list["Bush"] = true
func Tramp_update():
	%Tramp.visible = true
	GlobalFuncNVar.objs_list["Tramp"] = true
func Tube_update():
	%Tube.visible = true
	GlobalFuncNVar.objs_list["Tube"] = true
func House_update():
	%House.visible = true
	GlobalFuncNVar.objs_list["House"] = true
func Bowl_update():
	%Bowl.visible = true
func Tramp_frame(frame):
	%Tramp.set_frame_and_progress(frame,0.0)
func Bowl_food(state):
	if state > 0:
		%Bowl.set_frame_and_progress(1,0.0)
	else:
		%Bowl.set_frame_and_progress(0,0.0)

func _process(delta):
	pass
