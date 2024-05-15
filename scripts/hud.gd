extends CanvasLayer


signal spawnrat(cost : int)
signal make_child(rat1 : Object, rat2 : Object)


var rat_label = Label.new()
var rlabel_timer = Timer.new()
var rat_line = LineEdit.new()
var bgroup1
var list_names : Array 

func _ready():
	food_bar_update()
	rat_bar_update()
	add_child(rat_label)
	add_child(rlabel_timer)
	rlabel_timer.timeout.connect(rlabel_timer_timeout)
	bgroup1 = %Food.get_button_group()
	if %Food.get_meta("Dict")["flag"] == false:
		%BrushB.icon = load("res://art/object2/brushbd.png")
	%Food.disabled = true

func _process(delta):
	pass
func money_update():
	%Money0.text = "MONEY: " + str(GlobalFuncNVar.money)
	%Money1.text = "MONEY: " + str(GlobalFuncNVar.money)
	%Money2.text = "MONEY: " + str(GlobalFuncNVar.money)
	pass 
func rat_info(rat_name,x,y):
	rat_line.visible = false
	rat_label.visible = true
	rat_label.text = rat_name
	rat_label.position.x = x
	rat_label.position.y = y
	rlabel_timer.start()
func rlabel_timer_timeout():
	rat_label.visible = false
func rat_rename(x,y):
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
	money_update()
func _on_mix_pressed():
	%Panel.visible = true
	option_buttons_update()
func option_buttons_update():
	%OB0.clear()
	%OB1.clear()
	for i in GlobalFuncNVar.rats_arr:
		%OB0.add_item(i.rat_name)
		%OB1.add_item(i.rat_name)	
func store_closed_pressed():
	%Shop.visible = false
func mix_closed_pressed():
	%Panel.visible = false
func buy_rat():
	if int(%CostRat.text) <= GlobalFuncNVar.money:
		if GlobalFuncNVar.rats_arr.size() >= GlobalFuncNVar.max_rats:
			return
		spawnrat.emit(int(%CostRat.text))
		money_update()
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
			GlobalFuncNVar.food = 5		
			food_bar_update()
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
func rat_bar_update():	
	if GlobalFuncNVar.rats_arr.size() <= 8:
		%ratrect0.scale.x = 0.037 + float(GlobalFuncNVar.rats_arr.size())
		%ratrect1.scale.x = 0.0
	if GlobalFuncNVar.rats_arr.size() >= 9 and GlobalFuncNVar.rats_arr.size() <= 16:
		%ratrect1.scale.x = -8.038 + float(GlobalFuncNVar.rats_arr.size())

func food_bar_update():
	%foodrect.scale.x = GlobalFuncNVar.food
	GlobalFuncNVar.food_in_bowl.emit(GlobalFuncNVar.food)
func _on_food_timer_timeout():
	if GlobalFuncNVar.food > 0 and !GlobalFuncNVar.rats_arr.is_empty():
		GlobalFuncNVar.food -= 1
		food_bar_update()
		%Food.get_meta("Dict")["flag"] = false
func _on_shop_tab_changed(tab):
	%OB3.clear()
	for i in GlobalFuncNVar.rats_arr:
		%OB3.add_item(i.rat_name)
func _on_sell_pressed():
	var id = %OB3.get_selected_id()
	if id == -1:
		return
	if GlobalFuncNVar.rats_arr[id].genes.DNA == [GlobalFuncNVar.body_base,GlobalFuncNVar.ears_base,GlobalFuncNVar.eyes_base,GlobalFuncNVar.legs_base
,GlobalFuncNVar.nose_base,GlobalFuncNVar.tail_base] and GlobalFuncNVar.rats_arr[id].genes.color == GlobalFuncNVar.grey and GlobalFuncNVar.rats_arr[id].genes.global_genes == {
	"fluffy":false, "size":0.5} :
		GlobalFuncNVar.money += 900
	else:
		GlobalFuncNVar.money += 1200
	money_update()
	GlobalFuncNVar.rats_arr[id].queue_free() 
	GlobalFuncNVar.rats_arr.remove_at(id)
	rat_bar_update()
	_on_shop_tab_changed(%OB3.get_selected())

