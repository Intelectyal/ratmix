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

func _ready():
	name_generator()
	randomspawn()
	rat_generate()

func anim_flag_change():
	obj_anim_flag = !obj_anim_flag

func _on_timer_timeout():
	if true:
		#var i = GlobalFuncNVar.roulette(10)
		var i = randi_range(0,2)
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
					for j in GlobalFuncNVar.objs_list:
						if GlobalFuncNVar.objs_list[j]:
							GlobalFuncNVar.objs_list[j]=false
							rat_on_obj = j
							run_state = 2
							target = GlobalFuncNVar.objs_coord[j]
							return
	pass

func _input(event):
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
			#GlobalFuncNVar.objs_list[rat_on_obj]=true
			GlobalFuncNVar.obj_start_animation.emit(rat_on_obj)
			anim_flag_change()
		if run_state == 1 and number_of_pos <= 3:
			number_of_pos += 1
			
func anim_obj():
	#print("АНИМАЦИЮ УКРАЛИ")
	pass

func _physics_process(delta):	
	rat_run(delta)
	if anim_flag_change:
		anim_obj()

func _on_character_body_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("mouse_left"):
		rat_signal_left.emit(rat_index)
	elif Input.is_action_pressed("mouse_right"):
		rat_signal_right.emit(rat_index)
		

func name_generator():#генератор имён
	rat_name += GlobalFuncNVar.FirstName[randi_range(0,GlobalFuncNVar.FirstName.size()-1)]
	rat_name += GlobalFuncNVar.SecondName[randi_range(0,GlobalFuncNVar.SecondName.size()-1)]

func randomspawn():#дает крысе случайные координаты
	position.x = randi_range(500*0.5,600*0.5)
	position.y = randi_range(600,900)
	target = position

func rat_generate():# генерирует крысы (Кажется нужно переделать 	
	new_rat()
	$spots.visible = false
	

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
	
	
func gen_mixer(rat1 : Object, rat2 : Object):
	genes.global_genes["fluffy"] = choose_parent(rat1.genes.global_genes["fluffy"],rat2.genes.global_genes["fluffy"])
	if randi_range(0,100) <= genes.mutation_chance:
		genes.global_genes["fluffy"] = true
	if genes.global_genes["fluffy"] == true:
		genes.DNA[0] = GlobalFuncNVar.body_fluffy
	for i in (genes.DNA.size()-1):
		if i == 0:
			continue
		if 	!randi_range(0,100) <= genes.mutation_chance:
			genes.DNA[i] = choose_parent(rat1.genes.DNA[i],rat2.genes.DNA[i])
			continue	
		print("say something")	
		genes.DNA[i] = genes.DNA[i]["neighb"][randi_range(0,genes.DNA[i]["neighb"].size()-1)]
		print(genes.DNA[i])
	if rat1.genes.color["summable"].size() != 0 and rat2.genes.color["summable"].size() != 0 and rat1.genes.color["summable"] != rat2.genes.color["summable"]:
		for i in rat1.genes.color["summable"].size()-1:
			if rat2.genes.color["summable"].find(rat1.genes.color["summable"][i]):
				genes.color = rat1.genes.color["summable"][i]
				print(genes.color["value"]," сложился")
				return
	elif randi_range(0,100) <= genes.mutation_chance:	
		genes.color = genes.color["neighb"][randi_range(0,genes.color["neighb"].size()-1)]
		print(genes.color["value"]," мутировал")
		return
	else:
		genes.color = choose_parent(rat1.genes.color,rat2.genes.color)
		print(genes.color["value"]," передался")
		return

	
			
func choose_parent(a,b):
	match (randi_range(1,2)):
			1:
				return a
			2:
				return b	 
