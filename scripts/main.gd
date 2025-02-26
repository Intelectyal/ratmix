extends Node2D

var mess_scene = preload("res://scene/mess.tscn")
var rat_scene = preload("res://scene/rat_scene.tscn")
var mess_arr : Array



func _ready():
	%Food_timer.set_wait_time(Globalvariables.FoodTime)
	Globalvariables.screen_size = get_viewport_rect().size
	Globalvariables.money = 20000
	shelftile()
	GlobalSignals.shelf_buy.connect(shelftile)
	%TileMap.set_layer_enabled(1,false)
	GlobalSignals.food_is_buy.connect(food_update)
	GlobalSignals.rat_sell.connect(rat_is_sell)
	Globalvariables.discovered_genes.append_array(base_genes_array())
	GlobalSignals.calculate_happiness.connect(rats_happiness)
	GlobalSignals.delet_mess.connect(delet_mess)
	rats_happiness()
#	get_tree().paused = true <- пауза

	

func _process(delta):
	pass

func delet_mess(object):
	mess_arr.erase(object)
	GlobalSignals.calculate_happiness.emit()

func shelftile():
	%TileMap.set_layer_enabled(1,true)
func rat_construct(): #Создает сцену с крысой и знаносит крысу в массив rats
	Globalvariables.FoodTime -= 7.0 
	%Food_timer.set_wait_time(Globalvariables.FoodTime)	
	if Globalvariables.rats_arr.is_empty() and %Food_timer.is_paused():
		%Food_timer.set_paused(false)
	elif Globalvariables.rats_arr.is_empty():
		%Food_timer.start()
	Globalvariables.rats_arr.append(rat_scene.instantiate())
	var rat = Globalvariables.rats_arr.back()
	$Timer_mess.wait_time -= 0.5
	return rat
	
func rat_is_sell(id : int):
	Globalvariables.money += Globalvariables.rats_arr[id].cost
	Globalvariables.FoodTime += 7.0
	%Food_timer.set_wait_time(Globalvariables.FoodTime)
	Globalvariables.rats_arr[id].queue_free() 
	Globalvariables.rats_arr.remove_at(id)
	if Globalvariables.rats_arr.is_empty():
		%Food_timer.set_paused(true)
		
func _on_hud_make_child(parent0 : Object,parent1 : Object): #тестовая кнопка, создающая потомка крысы 1 и 2
	if !parent0.breedable:
		return
	if !parent1.breedable:
		return
	var rat = rat_construct()
	if rat == null:
		return
	parent0.breeded()
	parent1.breeded()
	rat.gen_mixer(parent0,parent1)
	new_gene_notification(rat.genes.return_genes_array(),Globalvariables.discovered_genes)
	rat.new_rat()
	add_child(rat)
	rat.randomspawn()
	rat.child()

func _on_hud_spawnrat(cost): #СПАВНИТ КРЫСУ ПО НАЖАТИЮ КНОПКИ
	var rat = rat_construct()
	rat.forced_breath()
	Globalvariables.money -= cost
	add_child(rat)
	

func base_genes_array()-> Array:
	var alpa_rat = rat_scene.instantiate()
	var array = alpa_rat.genes.return_genes_array()
	alpa_rat.queue_free()
	return alpa_rat.genes.return_genes_array()



	
func rats_happiness():
	var rats_amount : int = 0
	var toy_amount : int = 0
	var mess_amount : int = 0
	var happiness : int = 0
	
	rats_amount = Globalvariables.rats_arr.size()
	if rats_amount == 0: 
		GlobalSignals.happiness_sig.emit(0)
		return 
	mess_amount = mess_arr.size()	
	for i in Globalvariables.objs_list:
		if Globalvariables.objs_list[i]:
			toy_amount += 1
	happiness -= mess_amount
	happiness += toy_amount
	if rats_amount == 1:
		happiness -= 2
	if rats_amount > 1 and rats_amount <= 15:
		happiness += 2
	if rats_amount > 15:
		happiness -= 1
	happiness = clamp(happiness,0,5)
	GlobalSignals.happiness_sig.emit(happiness)
	


func _on_timer_mess():
	if mess_arr.size() < 5:
		mess_arr.append(mess_scene.instantiate())
		var mess = mess_arr.back()
		mess.index = mess_arr.find(mess)
		add_child(mess)
		GlobalSignals.calculate_happiness.emit()
	
func food_update():
	if Globalvariables.food == 0:
		%Food_timer.start()
	Globalvariables.food = 5
	GlobalSignals.food_timer.emit(Globalvariables.food)

func _on_food_timer_timeout():
	if Globalvariables.food > 0 and !Globalvariables.rats_arr.is_empty():
		Globalvariables.food -= 1
	if Globalvariables.food == 0 and !Globalvariables.rats_arr.is_empty():
		GlobalSignals.my_notification.emit("У крыс закончился корм\n Срочно купите еды")
		%Food_timer.stop()
		#здесь должен стартовать новый таймер для gameover
	GlobalSignals.food_timer.emit(Globalvariables.food)

func timer_food_start():
	if %Food_timer.time_left == 0.0:
		%Food_timer.start()
	

func new_gene_notification(verifiable_array : Array = [], checked_array : Array = [])-> void:
	if verifiable_array.is_empty():
		return
	if checked_array.is_empty():
		return
	for i in verifiable_array.size():
		if checked_array.has(verifiable_array[i]):
			continue
		else:
			checked_array.append(verifiable_array[i])
			if verifiable_array[i] == verifiable_array.back():
				GlobalSignals.my_notification.emit("Новая мутация\n Мутировал цвет")
				print(typeof(verifiable_array[i].keys())," -> ", verifiable_array[i].keys())
				continue
			var arr : Array = []
			arr = path_to_name(verifiable_array[i])
			print(arr,"хуй")
			if arr != []:
				var str ="Новая мутация!\nМутировал - " + arr[0] + "\nТир - " + arr[1] + "\nНомер - " + arr[2]
				GlobalSignals.my_notification.emit(str)
		
func path_to_name(dict : Dictionary):
	var answer : Array = []
	var str
	if dict.get("fur") != null:
		str = dict.get("fur").split("/")
		answer.append(str[-3])
		answer.append(str[-2][4])
		answer.append(str[-1][0])
	elif dict.get("skin") != null:
		str = dict.get("skin").split("/")
		answer.append(str[-3])
		answer.append(str[-2][4])
		answer.append(str[-1][0])
	else:
		return []
	return answer
