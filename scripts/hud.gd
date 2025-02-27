extends CanvasLayer


signal spawnrat(cost : int)
signal make_child(rat1 : Object, rat2 : Object)



var rat_line_scene = preload("res://scene/name_edit_line.tscn")
var bgroup1
var list_names : Array 
var notif_array : Array[String] = []

func _ready():
	food_bar_update(0) #обнуляет food bar полностью
	GlobalSignals.food_timer.connect(food_bar_update)
	rat_bar_update()
	bgroup1 = %Food.get_button_group()
	if %Food.get_meta("Dict")["flag"] == false: #понять зачем я ее сделал
		%BrushB.icon = load("res://art/object2/brushbd.png")
	%Food.disabled = true
	GlobalSignals.my_notification.connect(queue_notification)
	GlobalSignals.happiness_sig.connect(happy_bar_update)
	GlobalSignals.rat_signal_l.connect(rat_info)
	GlobalSignals.rat_signal_r.connect(rat_rename)
	GlobalSignals.no_pressed.connect(line_pressed_no)
	GlobalSignals.ok_pressed.connect(line_pressed_ok)
	
	
func preview_string(text : String):
	text = text.insert(13,"_preview")
	return(text)
	
func preview(id,choice):
	var node = get_node("%SubViewport"+str(choice))	
	node.find_child("body").texture = ResourceLoader.load(preview_string(Globalvariables.rats_arr[id].genes.DNA[0]["fur"]))	
	node.find_child("body").modulate = Globalvariables.rats_arr[id].genes.color["value"]
	node.find_child("ears_f").texture = ResourceLoader.load(preview_string(Globalvariables.rats_arr[id].genes.DNA[1]["fur"]))
	node.find_child("ears_s").texture = ResourceLoader.load(preview_string(Globalvariables.rats_arr[id].genes.DNA[1]["skin"]))
	node.find_child("ears_f").modulate = Globalvariables.rats_arr[id].genes.color["value"]
	node.find_child("eyes").texture = ResourceLoader.load(preview_string(Globalvariables.rats_arr[id].genes.DNA[2]["skin"]))
	node.find_child("legs_f").texture = ResourceLoader.load(preview_string(Globalvariables.rats_arr[id].genes.DNA[3]["fur"]))
	node.find_child("legs_s").texture = ResourceLoader.load(preview_string(Globalvariables.rats_arr[id].genes.DNA[3]["skin"]))
	node.find_child("legs_f").modulate = Globalvariables.rats_arr[id].genes.color["value"]
	node.find_child("nose_f").texture = ResourceLoader.load(preview_string(Globalvariables.rats_arr[id].genes.DNA[4]["fur"]))
	node.find_child("nose_s").texture = ResourceLoader.load(preview_string(Globalvariables.rats_arr[id].genes.DNA[4]["skin"]))
	node.find_child("nose_f").modulate = Globalvariables.rats_arr[id].genes.color["value"]	
	node.find_child("tail_f").texture = ResourceLoader.load(preview_string(Globalvariables.rats_arr[id].genes.DNA[5]["fur"]))
	node.find_child("tail_s").texture = ResourceLoader.load(preview_string(Globalvariables.rats_arr[id].genes.DNA[5]["skin"]))
	node.find_child("tail_f").modulate = Globalvariables.rats_arr[id].genes.color["value"]	

func _process(delta):
	pass
	
func money_update():
	%Money0.set_text("MONEY: " + str(Globalvariables.money))
	%Money1.set_text("MONEY: " + str(Globalvariables.money))
	%Money2.set_text("MONEY: " + str(Globalvariables.money))
	
func rat_info(rat):
	var rat_label = Label.new()
	add_child(rat_label)
	var rlabel_timer = Timer.new()
	rlabel_timer.set_wait_time(3.0)
	add_child(rlabel_timer)
	rlabel_timer.timeout.connect(rlabel_timer_timeout.bind(rat, rat_label,rlabel_timer))
	rat_label.visible = true
	rat_label.text = rat.rat_name
	rat_label.position = rat.position + Vector2(-25.0,-55.0)
	rlabel_timer.start()
	rat.set_physics_process(false)



func rlabel_timer_timeout(rat : Object, rat_label : Object, rat_timer : Object):
	rat.set_physics_process(true)
	delete_label(rat_label,rat_timer)
	
func delete_label(rat_label, rat_timer):
	rat_label.queue_free()
	rat_timer.queue_free()


func line_pressed_no(line : Object):
	line.queue_free()

func line_pressed_ok(line : Object, new_name : String):
	line.queue_free()
	GlobalSignals.my_notification.emit("Новое имя крысы теперь: <" + new_name + "> !")

var line_array : Array = []
func rat_rename(rat : Object): #ПЕРЕДЕЛАТЬ
	var line = rat_line_scene.instantiate()
	line_array.append(line)
	add_child(line)
	line.position = rat.position + Vector2(-55.0,+55.0)
	line.scale = Vector2(0.75,0.75)
	rat.set_physics_process(false)
	GlobalSignals.line_set_rat.emit(rat)

func _on_brush_pressed():
	if Globalvariables.Brush == null:
		return
	if Globalvariables.Brush == true:
		Globalvariables.Brush = false
		Input.set_custom_mouse_cursor(null)
		return
	Globalvariables.Brush = true
	Input.set_custom_mouse_cursor(Globalvariables.Brush_cursor)
		

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
	for i in Globalvariables.rats_arr:
		%OB0.add_item(i.rat_name)
		%OB1.add_item(i.rat_name)	

func store_closed_pressed():
	%Shop.visible = false
	Hudflag()

func mix_closed_pressed():
	%Panel.visible = false
	Hudflag()

func buy_rat():
	if int(%CostRat.text) <= Globalvariables.money:
		if Globalvariables.rats_arr.size() >= Globalvariables.max_rats:
			return
		spawnrat.emit(int(%CostRat.text))
		money_update()
		rat_bar_update()
		

func buy_item():
	if  !is_instance_valid(bgroup1.get_pressed_button()):
		return
	if bgroup1.get_pressed_button().get_meta("cost") <= Globalvariables.money and bgroup1.get_pressed_button().get_meta("Dict")["flag"] != true:	
		Globalvariables.money -= bgroup1.get_pressed_button().get_meta("cost")
		money_update()
		bgroup1.get_pressed_button().get_meta("Dict")["flag"] = true
		items_update(bgroup1.get_pressed_button().get_meta("Dict")["name"],bgroup1.get_pressed_button().get_meta("Dict")["flag"])	
	GlobalSignals.calculate_happiness.emit()

func show_cost_items():	
	%CostItem.text = "COST: " + str(bgroup1.get_pressed_button().get_meta("cost"))
	
func items_update(item_name, flag):
	match item_name:
		"Food":
			GlobalSignals.food_is_buy.emit()
		"Shelf":
				GlobalSignals.shelf_buy.emit()
				Globalvariables.shelf_is_buy = true
		"Brush":
				%BrushB.icon = load("res://art/object2/brushbp.png")
				Globalvariables.Brush = true
		"House":
				GlobalSignals.House_buy.emit()
		"Wheel":
				GlobalSignals.Wheel_buy.emit()
		"Bush":
				GlobalSignals.Bush_buy.emit()
		"Tramp":
				GlobalSignals.Tramp_buy.emit()
		"Tube":
				GlobalSignals.Tube_buy.emit()
		"Bowl":
				%Food.disabled = false
				GlobalSignals.Bowl_buy.emit()
		_:
			pass		

func _on_make_child_pressed():
	if %OB0.get_selected_id() == %OB1.get_selected_id():
		return
	make_child.emit(Globalvariables.rats_arr[%OB0.get_selected_id()],Globalvariables.rats_arr[%OB1.get_selected_id()])
	rat_bar_update()
	option_buttons_update()
	_list_sell_update()

func rat_bar_update():	#обновляет шкалу количества крыс
	if Globalvariables.rats_arr.size() <= 8:
		%ratrect0.scale.x = 0.037 + float(Globalvariables.rats_arr.size())
		%ratrect1.scale.x = 0.0
	if Globalvariables.rats_arr.size() >= 9 and Globalvariables.rats_arr.size() <= 16:
		%ratrect1.scale.x = -8.01 + float(Globalvariables.rats_arr.size())
	GlobalSignals.calculate_happiness.emit()
	
func happy_bar_update(happy : int):
	%happyrect.scale.x = happy
#	print("happy: ", happy)
	return
func food_bar_update(food : int):
	%foodrect.scale.x = food
	GlobalSignals.food_in_bowl.emit(food)
	%Food.get_meta("Dict")["flag"] = false

func _on_shop_tab_changed(tab): #обработчик изменения вкладок магазина
	if %Shop.current_tab == 2:
		GlobalSignals.rats_cost.emit()
	_list_sell_update()

	
	
func _list_sell_update(): #обновляет список мышей на продажу
	%OB3.clear()
	for i in Globalvariables.rats_arr:
		%OB3.add_item(i.rat_name)

func _on_sell_pressed(): #функция продажи
	var id = %OB3.get_selected_id()
	if id == -1:
		return
	GlobalSignals.rat_sell.emit(id)
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
	%Notif_anim.play("notification")
	%Notification.visible = true
	%Notification.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
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
		Globalvariables.HudFlag = true
	if !%Shop.is_visible() and !%Panel.is_visible():
		Globalvariables.HudFlag = false
