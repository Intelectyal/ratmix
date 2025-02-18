extends Node2D

var mess_scene = preload("res://scene/mess.tscn")
var rat_scene = preload("res://scene/rat_scene.tscn")
#var rats = []
var mess_arr : Array



func _ready():
	%Food_timer.set_wait_time(GlobalFuncNVar.FoodTime)
	GlobalFuncNVar.screen_size = get_viewport_rect().size
	GlobalFuncNVar.money = 20000
	shelftile()
	GlobalFuncNVar.shelf_buy.connect(shelftile)
	%TileMap.set_layer_enabled(1,false)
	GlobalFuncNVar.food_is_buy.connect(food_update)
	GlobalFuncNVar.rat_sell.connect(rat_is_sell)
	GlobalFuncNVar.discovered_genes.append_array(base_genes_array())
	print(GlobalFuncNVar.discovered_genes.size())

func _process(delta):
	pass

func brush_cursor(vis):
	pass

func shelftile():
	%TileMap.set_layer_enabled(1,true)
func rat_construct(): #Создает сцену с крысой и знаносит крысу в массив rats
	GlobalFuncNVar.FoodTime -= 7.0 
	%Food_timer.set_wait_time(GlobalFuncNVar.FoodTime)	
	if GlobalFuncNVar.rats_arr.is_empty() and %Food_timer.is_paused():
		%Food_timer.set_paused(false)
	elif GlobalFuncNVar.rats_arr.is_empty():
		%Food_timer.start()
	GlobalFuncNVar.rats_arr.append(rat_scene.instantiate())
	var rat = GlobalFuncNVar.rats_arr.back()
	rat.rat_signal_left.connect(_on_rat_scene_rat_signal_left)
	rat.rat_signal_right.connect(_on_rat_scene_rat_signal_right)
	rat.rat_index = GlobalFuncNVar.rats_arr.find(rat)
	$Timer_mess.wait_time -= 0.5
	return rat
	
func rat_is_sell(id : int):
	GlobalFuncNVar.money += GlobalFuncNVar.rats_arr[id].cost
	GlobalFuncNVar.FoodTime += 7.0
	%Food_timer.set_wait_time(GlobalFuncNVar.FoodTime)
	GlobalFuncNVar.rats_arr[id].queue_free() 
	GlobalFuncNVar.rats_arr.remove_at(id)
	if GlobalFuncNVar.rats_arr.is_empty():
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
	rat.new_rat()
	add_child(rat)
	rat.randomspawn()
	rat.child()

func _on_hud_spawnrat(cost): #СПАВНИТ КРЫСУ ПО НАЖАТИЮ КНОПКИ
	var rat = rat_construct()
	rat.forced_breath()
	GlobalFuncNVar.money -= cost
	add_child(rat)
	

func base_genes_array()-> Array:
	var alpa_rat = rat_scene.instantiate()
	var array = alpa_rat.genes.return_genes_array()
	alpa_rat.queue_free()
	return alpa_rat.genes.return_genes_array()

func _on_rat_scene_rat_signal_left(rat_index):
	var rat = GlobalFuncNVar.rats_arr[rat_index]
	$HUD.rat_info(rat.rat_name,rat.position.x-40,rat.position.y-75)


func _on_rat_scene_rat_signal_right(rat_index):
	var rat = GlobalFuncNVar.rats_arr[rat_index]
	rat.rat_name = $HUD.rat_rename(rat.position.x-40,rat.position.y-75)
	



func _on_timer_mess():
	mess_arr.append(mess_scene.instantiate())
	var mess = mess_arr[mess_arr.size()-1]
	mess.index = mess_arr.find(mess)
	add_child(mess)
	
func food_update():
	if GlobalFuncNVar.food == 0:
		%Food_timer.start()
	GlobalFuncNVar.food = 5
	GlobalFuncNVar.food_timer.emit(GlobalFuncNVar.food)

func _on_food_timer_timeout():
	if GlobalFuncNVar.food > 0 and !GlobalFuncNVar.rats_arr.is_empty():
		GlobalFuncNVar.food -= 1
	if GlobalFuncNVar.food == 0 and !GlobalFuncNVar.rats_arr.is_empty():
		GlobalFuncNVar.my_notification.emit("У крыс закончился корм\n Срочно купите еды")
		%Food_timer.stop()
		#здесь должен стартовать новый таймер для gameover
	GlobalFuncNVar.food_timer.emit(GlobalFuncNVar.food)

func timer_food_start():
	if %Food_timer.time_left == 0.0:
		%Food_timer.start()
	

func new_gene_notification(verifiable_array : Array = [])-> void:
	return
	pass
