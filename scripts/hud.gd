extends CanvasLayer


signal spawnrat(cost : int)
signal make_child(rat1 : Object, rat2 : Object)


var rat_label = Label.new()
var rlabel_timer = Timer.new()
var rat_line = LineEdit.new()
var bgroup1
var list_names : Array 
var notif_array : Array[String] = []

func _ready():
	food_bar_update(0) #обнуляет food bar полностью
	GlobalFuncNVar.food_timer.connect(food_bar_update)
	rat_bar_update()
	add_child(rat_label)
	add_child(rlabel_timer)
	rlabel_timer.timeout.connect(rlabel_timer_timeout)
	bgroup1 = %Food.get_button_group()
	if %Food.get_meta("Dict")["flag"] == false: #понять зачем я ее сделал
		%BrushB.icon = load("res://art/object2/brushbd.png")
	%Food.disabled = true
	GlobalFuncNVar.my_notification.connect(queue_notification)

	
func preview_string(text : String):
	text = text.insert(13,"_preview")
	return(text)
	
func preview(id,choice):
	var node = get_node("%SubViewport"+str(choice))	
	node.find_child("body").texture = ResourceLoader.load(preview_string(GlobalFuncNVar.rats_arr[id].genes.DNA[0]["fur"]))	
	node.find_child("body").modulate = GlobalFuncNVar.rats_arr[id].genes.color["value"]
	node.find_child("ears_f").texture = ResourceLoader.load(preview_string(GlobalFuncNVar.rats_arr[id].genes.DNA[1]["fur"]))
	node.find_child("ears_s").texture = ResourceLoader.load(preview_string(GlobalFuncNVar.rats_arr[id].genes.DNA[1]["skin"]))
	node.find_child("ears_f").modulate = GlobalFuncNVar.rats_arr[id].genes.color["value"]
	node.find_child("eyes").texture = ResourceLoader.load(preview_string(GlobalFuncNVar.rats_arr[id].genes.DNA[2]["skin"]))
	node.find_child("legs_f").texture = ResourceLoader.load(preview_string(GlobalFuncNVar.rats_arr[id].genes.DNA[3]["fur"]))
	node.find_child("legs_s").texture = ResourceLoader.load(preview_string(GlobalFuncNVar.rats_arr[id].genes.DNA[3]["skin"]))
	node.find_child("legs_f").modulate = GlobalFuncNVar.rats_arr[id].genes.color["value"]
	node.find_child("nose_f").texture = ResourceLoader.load(preview_string(GlobalFuncNVar.rats_arr[id].genes.DNA[4]["fur"]))
	node.find_child("nose_s").texture = ResourceLoader.load(preview_string(GlobalFuncNVar.rats_arr[id].genes.DNA[4]["skin"]))
	node.find_child("nose_f").modulate = GlobalFuncNVar.rats_arr[id].genes.color["value"]	
	node.find_child("tail_f").texture = ResourceLoader.load(preview_string(GlobalFuncNVar.rats_arr[id].genes.DNA[5]["fur"]))
	node.find_child("tail_s").texture = ResourceLoader.load(preview_string(GlobalFuncNVar.rats_arr[id].genes.DNA[5]["skin"]))
	node.find_child("tail_f").modulate = GlobalFuncNVar.rats_arr[id].genes.color["value"]	

func _process(delta):
	pass
	
func money_update():
	%Money0.set_text("MONEY: " + str(GlobalFuncNVar.money))
	%Money1.set_text("MONEY: " + str(GlobalFuncNVar.money))
	%Money2.set_text("MONEY: " + str(GlobalFuncNVar.money))
	
func rat_info(rat_name,x,y):
	rat_line.visible = false
	rat_label.visible = true
	rat_label.text = rat_name
	rat_label.position.x = x
	rat_label.position.y = y
	rlabel_timer.start()

func rlabel_timer_timeout():
	rat_label.visible = false
	
func rat_rename(x,y): #ПЕРЕДЕЛАТЬ
	rat_label.visible = false
	rat_line.visible = true
	var new_name = "ЗАГЛУШКА"
	add_child(rat_line)
	rat_line.scale.x = 1
	rat_line.scale.y = 1
	rat_line.position.x = x
	rat_line.position.y = y
	rat_line.placeholder_text = "name"
	return new_name

func _on_brush_pressed():
	if GlobalFuncNVar.Brush == null:
		return
	if GlobalFuncNVar.Brush == true:
		GlobalFuncNVar.Brush = false
		Input.set_custom_mouse_cursor(null)
		return
	GlobalFuncNVar.Brush = true
	Input.set_custom_mouse_cursor(GlobalFuncNVar.Brush_cursor)
	return	

func _on_shop_pressed():
	%Shop.visible = true
	Hudflag()
	money_update()

func _on_mix_pressed():
	%Panel.visible = true
	Hudflag()
	option_buttons_update()
	

func option_buttons_update(): #обновляет списки в окне скрещивания
	%OB0.clear()
	%OB1.clear()
	for i in GlobalFuncNVar.rats_arr:
		%OB0.add_item(i.rat_name)
		%OB1.add_item(i.rat_name)	

func store_closed_pressed():
	%Shop.visible = false
	Hudflag()

func mix_closed_pressed():
	%Panel.visible = false
	Hudflag()

func buy_rat():
	if int(%CostRat.text) <= GlobalFuncNVar.money:
		if GlobalFuncNVar.rats_arr.size() >= GlobalFuncNVar.max_rats:
			return
		spawnrat.emit(int(%CostRat.text))
		money_update()
		rat_bar_update()
		

func buy_item():
	if  !is_instance_valid(bgroup1.get_pressed_button()):
		return
	if bgroup1.get_pressed_button().get_meta("cost") <= GlobalFuncNVar.money and bgroup1.get_pressed_button().get_meta("Dict")["flag"] != true:	
		GlobalFuncNVar.money -= bgroup1.get_pressed_button().get_meta("cost")
		money_update()
		bgroup1.get_pressed_button().get_meta("Dict")["flag"] = true
		items_update(bgroup1.get_pressed_button().get_meta("Dict")["name"],bgroup1.get_pressed_button().get_meta("Dict")["flag"])	

func show_cost_items():	
	%CostItem.text = "COST: " + str(bgroup1.get_pressed_button().get_meta("cost"))
	
func items_update(item_name, flag):
	match item_name:
		"Food":
			GlobalFuncNVar.food_is_buy.emit()
		"Shelf":
				GlobalFuncNVar.shelf_buy.emit()
				GlobalFuncNVar.shelf_is_buy = true
		"Brush":
				%BrushB.icon = load("res://art/object2/brushbp.png")
				GlobalFuncNVar.Brush = true
		"House":
				GlobalFuncNVar.House_buy.emit()
		"Wheel":
				GlobalFuncNVar.Wheel_buy.emit()
		"Bush":
				GlobalFuncNVar.Bush_buy.emit()
		"Tramp":
				GlobalFuncNVar.Tramp_buy.emit()
		"Tube":
				GlobalFuncNVar.Tube_buy.emit()
		"Bowl":
				%Food.disabled = false
				GlobalFuncNVar.Bowl_buy.emit()
		_:
			pass		

func _on_make_child_pressed():
	if %OB0.get_selected_id() == %OB1.get_selected_id():
		return
	make_child.emit(GlobalFuncNVar.rats_arr[%OB0.get_selected_id()],GlobalFuncNVar.rats_arr[%OB1.get_selected_id()])
	option_buttons_update()
	_list_sell_update()

func rat_bar_update():	#обновляет шкалу количества крыс
	if GlobalFuncNVar.rats_arr.size() <= 8:
		%ratrect0.scale.x = 0.037 + float(GlobalFuncNVar.rats_arr.size())
		%ratrect1.scale.x = 0.0
	if GlobalFuncNVar.rats_arr.size() >= 9 and GlobalFuncNVar.rats_arr.size() <= 16:
		%ratrect1.scale.x = -8.038 + float(GlobalFuncNVar.rats_arr.size())
	

func food_bar_update(food : int):
	%foodrect.scale.x = food
	GlobalFuncNVar.food_in_bowl.emit(food)
	%Food.get_meta("Dict")["flag"] = false

func _on_shop_tab_changed(tab): #обработчик изменения вкладок магазина
	if %Shop.current_tab == 2:
		GlobalFuncNVar.rats_cost.emit()
	_list_sell_update()

	
	
func _list_sell_update(): #обновляет список мышей на продажу
	%OB3.clear()
	for i in GlobalFuncNVar.rats_arr:
		%OB3.add_item(i.rat_name)

func _on_sell_pressed(): #функция продажи
	var id = %OB3.get_selected_id()
	if id == -1:
		return
	GlobalFuncNVar.rat_sell.emit(id)
	money_update()
	rat_bar_update()
	_list_sell_update()
	option_buttons_update()
	


func _on_ob_0_item_selected(index):
	preview(%OB0.get_selected_id(),0)


func _on_ob_1_item_selected(index):
	preview(%OB1.get_selected_id(),1)


func _notification_close():#Закрывает уведомление
	%Notification.visible = false
	queue_notification() #проверяет нет ли еще уведомлений
func show_my_notification(text : String): #показывает уведомление
	%Notification.visible = true
	%Nlabel.set_text(text)
	
func queue_notification(text : String = ""): #очередь уведомлений
	if !text.is_empty():
		notif_array.append(text)
	if notif_array.is_empty():
		return -1
	if %Notification.visible == false:
		show_my_notification(notif_array.front())
		notif_array.pop_front()
func Hudflag():
	if %Shop.is_visible() or %Panel.is_visible():
		GlobalFuncNVar.HudFlag = true
	if !%Shop.is_visible() and !%Panel.is_visible():
		GlobalFuncNVar.HudFlag = false
