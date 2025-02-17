extends CharacterBody2D

signal rat_signal_left(rat_index)
signal rat_signal_right(rat_index)


var rat_speed = 40000
var rat_name = ""
var rat_index = ""
var rat_gen = load("res://scripts/rat_genes.gd")
var genes = rat_gen.new()
var target 
var run_state : int 
var counter_pos : Vector2
var number_of_pos : int = -1
var rat_on_obj
var obj_anim_flag : bool = false
var breedable : bool = true
var cost : int = 0

func _ready():
	name_generator()
	randomspawn()
	rat_generate()
	GlobalFuncNVar.rats_cost.connect(cost_calculation)

func anim_flag_change():
	obj_anim_flag = !obj_anim_flag
func _on_breedable_timeout():
	breedable = true
func breeded():
	breedable = false
	%Breedable.start()
func _on_timer_timeout():
	if true:
		#var i = GlobalFuncNVar.roulette(10)
		var i = randi_range(0,2)
#		var i = 2
		match (i):
			0:
				if velocity == Vector2(0.0,0.0) and run_state != 2:
					target = position + Vector2(randf_range(-500.0,500.0),randf_range(-500.0,500.0))	
					run_state = 0
				counter_pos = position
			1:
				if GlobalFuncNVar.shelf_is_buy and run_state != 2:
					if velocity == Vector2(0.0,0.0):
						if GlobalFuncNVar.rat_on_path == false:
							set_collision_mask_value(1,false)
							GlobalFuncNVar.rat_on_path = true
							run_state = 1
							number_of_pos = 0
			2:
				if velocity == Vector2(0.0,0.0) and run_state != 2:
					if !obj_anim_flag:
						for j in GlobalFuncNVar.objs_list:
							if GlobalFuncNVar.objs_list[j]:
								GlobalFuncNVar.objs_list[j]=false
								rat_on_obj = j
								run_state = 2
								target = GlobalFuncNVar.objs_coord[j]
								anim_flag_change()
								return
			_:
				pass
			
	pass

func _input(event):
	if GlobalFuncNVar.GuiFlag:
		return
	if event.is_action_pressed("mouse_left") and event.double_click and number_of_pos == -1 and run_state != 2:
		target = get_global_mouse_position()
		counter_pos = position
		run_state = 3

func rat_run(delta):
	if run_state == 1:
		match (number_of_pos):
			0:
				target = Vector2(448,576)
			1:
				target = Vector2(448,232)
			2:
				target = Vector2(1472,232)
			3:
				target = Vector2(1472,576)
			_:
				run_state = 0
				number_of_pos = -1
				GlobalFuncNVar.rat_on_path = false
				set_collision_mask_value(1,true)
	velocity = position.direction_to(target)*rat_speed*delta	
	if position.distance_to(target) > 10:
		move_and_slide()	
		if velocity <= Vector2(0.4,0.4) and abs((counter_pos-position)) < Vector2(0.7,0.7) and velocity != Vector2(0,0): #и велосити не равно нулю
			target = Vector2(randf_range(250,750),randf_range(600,750))
	else:
		velocity = Vector2(0.0,0.0)
		if run_state == 2: 
			GlobalFuncNVar.objs_list[rat_on_obj]=true 
			pass
		if run_state == 1 and number_of_pos <= 3:
			number_of_pos += 1
			
func anim_obj():
	if position.distance_to(target) > 10:
		return
	match rat_on_obj:
		"Wheel":
			%Rat_anim.play("wheel")
		"Bush":
			%Rat_anim.play("bush")
		"Tramp":
			%Rat_anim.play("tramp")
		"Tube":
			%Rat_anim.play("Tube")
	GlobalFuncNVar.obj_start_animation.emit(rat_on_obj)

func _physics_process(delta):	
	rat_run(delta)
	if obj_anim_flag:
		anim_obj()

func _on_character_body_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("mouse_left"):
		rat_signal_left.emit(rat_index)
	elif Input.is_action_pressed("mouse_right"):
		rat_signal_right.emit(rat_index)
		

func name_generator():#генератор имён
	rat_name += GlobalFuncNVar.FirstName.pick_random()
	rat_name += GlobalFuncNVar.SecondName.pick_random()

func randomspawn():#дает крысе случайные координаты
	position.x = randi_range(500*0.5,600*0.5)
	position.y = randi_range(600,900)
	target = position

func rat_generate():# генерирует крысы (Кажется нужно переделать 	
	new_rat()
#	$spots.visible = false
	

func new_rat():
	$body.texture = ResourceLoader.load(genes.DNA[0]["fur"])
	$body.modulate = genes.color["value"]
	$ears_f.texture = ResourceLoader.load(genes.DNA[1]["fur"])
	$ears_s.texture = ResourceLoader.load(genes.DNA[1]["skin"])
	$ears_f.modulate = genes.color["value"]
	$eyes.texture = ResourceLoader.load(genes.DNA[2]["skin"])
	$legs_f.texture = ResourceLoader.load(genes.DNA[3]["fur"])
	$legs_s.texture = ResourceLoader.load(genes.DNA[3]["skin"])
	$legs_f.modulate= genes.color["value"]
	$nose_f.texture = ResourceLoader.load(genes.DNA[4]["fur"])
	$nose_s.texture = ResourceLoader.load(genes.DNA[4]["skin"])
	$nose_f.modulate = genes.color["value"]	
	$tail_f.texture = ResourceLoader.load(genes.DNA[5]["fur"])
	$tail_s.texture = ResourceLoader.load(genes.DNA[5]["skin"])
	$tail_f.modulate = genes.color["value"]	
	if genes.color["spots"] == true:
		$spots.texture = ResourceLoader.load("res://art//rat//over//tier1//1.png")
		$spots.modulate = genes.color["value_s"]
#	$horns.texture = ResourceLoader.load()
#	$mouth.texture = ResourceLoader.load()
#	$wings.texture = ResourceLoader.load()
	
	
func gen_mixer(rat1 : Object, rat2 : Object):
	genes.global_genes["fluffy"] = choose_parent(rat1.genes.global_genes["fluffy"],rat2.genes.global_genes["fluffy"])
	if randi_range(0,100) <= genes.mutation_chance:
		genes.global_genes["fluffy"] = true
	if genes.global_genes["fluffy"] == true:
		genes.DNA[0] = GlobalFuncNVar.body_fluffy
	for i in (genes.DNA.size()):
		if i == 0:
			continue
		if 	!randi_range(0,100) <= genes.mutation_chance:
			genes.DNA[i] = choose_parent(rat1.genes.DNA[i],rat2.genes.DNA[i])
			continue	
		genes.DNA[i] = genes.DNA[i]["neighb"].pick_random()
	if rat1.genes.color != rat2.genes.color :
		for i in rat1.genes.color["neighb"].size():
			if rat2.genes.color["neighb"].has(rat1.genes.color["neighb"][i]): 
				genes.color = rat1.genes.color["neighb"][i]
				print("сложился")
				return
	genes.color = choose_parent(rat1.genes.color,rat2.genes.color)
	if randi_range(0,100) <= genes.mutation_chance:	
		print("мутация")
		var colors : Array = []
		for i in genes.color["neighb"]:
			if i["summable"] == false:
				colors.append(i)
		if !colors.is_empty():	
			genes.color = colors.pick_random()
		return

	
			
func choose_parent(a,b):
	match (randi_range(1,2)):
			1:
				return a
			2:
				return b	 


func _on_rat_anim_animation_finished(anim_name):
	anim_flag_change()
	GlobalFuncNVar.obj_stop_animation.emit(rat_on_obj)
	run_state = 0
	GlobalFuncNVar.objs_list[rat_on_obj] = true
func tramp_emit(frame):
	GlobalFuncNVar.tramp_frame.emit(frame)
	pass

func child():
	breedable = false
	%Rat_anim2.play("breath_child")
	scale = Vector2(0.25 , 0.25)
	%Adult.start()
func _on_adult_timeout():
	breedable = true
#	%Rat_anim2.stop()
	scale = Vector2(0.5 , 0.5)
	%Rat_anim2.play("breath_adult")
func forced_breath():
	%Rat_anim2.play("breath_adult")

func cost_calculation():
	var cost_array : Array
	if cost != 0:
		return
	for i in genes.DNA.size():
		if genes.DNA[i].get("skin") != null:
			cost_array.append(get_digit_before_last_slash(genes.DNA[i].get("skin")))
		elif genes.DNA[i].get("fur") != null:
			cost_array.append(get_digit_before_last_slash(genes.DNA[i].get("fur")))
		elif (genes.DNA[i].get("fur") == null and genes.DNA[i].get("skin") == null):
			cost_array.append(-1)
	cost = 100 * (
	cost_array[0] + 0.7 +  # тело
	cost_array[1] + 0.5 +  # уши
	cost_array[2] + 0.5 +  # глаза
	cost_array[3] + 0.7 +  # ноги
	cost_array[4] + 0.5 +  #нос
	cost_array[5] + 0.5 +  # хвост
	cost_array[6] + 0.5 +  # рога
	cost_array[7] + 0.5 +  # крылья
	cost_array[8] + 0.5   # рот
)
	cost += calculate_color_bonus_cost(genes.color)*80
	print(cost,"|||", calculate_color_bonus_cost(genes.color)*80 )
	

func calculate_color_bonus_cost(color : Dictionary = {}) -> int:
	var array : Array[Dictionary] = []
	var is_check : Array[Dictionary] = []
	var total_found : int = 0
	var dist_index : int = 0
	array.append_array(GlobalFuncNVar.grey["neighb"])
	for i in array:
		i["distance"] = 1
	while !array.is_empty():
		if !is_check.has(array.front()):
			if array.front() == color:
				total_found += 1
				dist_index = array.front()["distance"]
			for i in array.front()["neighb"]:
				i["distance"] = 1+array.front()["distance"]
			is_check.append(array.front())
			array.append_array(array.front()["neighb"])
		array.pop_front()
		is_check.erase(color)
	if total_found == 0:
		return 1
	return total_found*dist_index+1

func get_digit_before_last_slash(path: String) -> int:
	var last_slash_index = path.rfind("/")
	if last_slash_index == -1:
		return -1
	var digit_str = ""
	for i in range(last_slash_index - 1, -1, -1):
		if path[i].is_valid_int():
			digit_str = path[i] + digit_str
		else:
			break
	
	# Если цифра найдена, возвращаем её как число
	if digit_str != "":
		return digit_str.to_int()
	
	# Если цифра не найдена, возвращаем -1 (или можно выбросить ошибку)
	return -1


