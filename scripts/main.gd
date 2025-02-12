extends Node2D

var mess_scene = preload("res://scene/mess.tscn")
var rat_scene = preload("res://scene/rat_scene.tscn")
#var rats = []
var mess_arr : Array


func _ready():
	GlobalFuncNVar.screen_size = get_viewport_rect().size
	GlobalFuncNVar.money = 20000
	shelftile()
	GlobalFuncNVar.shelf_buy.connect(shelftile)
	%TileMap.set_layer_enabled(1,false)

func _process(delta):
	pass

func brush_cursor(vis):
	pass

func shelftile():
	%TileMap.set_layer_enabled(1,true)
func rat_construct(): #Создает сцену с крысой и знаносит крысу в массив rats
	GlobalFuncNVar.FoodTime -= 7.0
	$HUD/FoodTimer.set_wait_time(GlobalFuncNVar.FoodTime)
	#print(GlobalFuncNVar.rats_arr.size())	
	GlobalFuncNVar.rats_arr.append(rat_scene.instantiate())
	$HUD.rat_bar_update()
	var rat = GlobalFuncNVar.rats_arr[GlobalFuncNVar.rats_arr.size()-1]
	rat.rat_signal_left.connect(_on_rat_scene_rat_signal_left)
	rat.rat_signal_right.connect(_on_rat_scene_rat_signal_right)
	rat.rat_index = GlobalFuncNVar.rats_arr.find(rat)
	$Timer_mess.wait_time -= 0.5
	return rat
	

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
	
