extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.Wheel_buy.connect(Wheel_update)
	GlobalSignals.Bush_buy.connect(Bush_update)
	GlobalSignals.Tramp_buy.connect(Tramp_update)
	GlobalSignals.Tube_buy.connect(Tube_update)
	GlobalSignals.House_buy.connect(House_update)
	GlobalSignals.Bowl_buy.connect(Bowl_update)
	GlobalSignals.obj_start_animation.connect(start_animation)
	GlobalSignals.obj_stop_animation.connect(stop_animation)
	GlobalSignals.tramp_frame.connect(Tramp_frame)
	GlobalSignals.food_in_bowl.connect(Bowl_food)
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
	Globalvariables.objs_list["Wheel"] = true
func Bush_update():
	%Bush.visible = true
	Globalvariables.objs_list["Bush"] = true
func Tramp_update():
	%Tramp.visible = true
	Globalvariables.objs_list["Tramp"] = true
func Tube_update():
	%Tube.visible = true
	Globalvariables.objs_list["Tube"] = true
func House_update():
	%House.visible = true
	Globalvariables.objs_list["House"] = true
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
