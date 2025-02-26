extends Node

signal rats_cost
signal shelf_buy
signal Wheel_buy
signal Bush_buy
signal Tramp_buy
signal Tube_buy
signal House_buy
signal Bowl_buy
signal Bowl_food
signal obj_start_animation(name : String)
signal obj_stop_animation(name : String)
signal tramp_frame(frame : int)
signal food_in_bowl(state : bool)
signal my_notification(text : String)
signal food_timer(food : int) #MAIN -> HUD
signal food_is_buy() #HUD -> MAIN
signal rat_sell(id : int) # HUD -> MAIN 
signal happiness_sig(happy : int) # MAIN -> HUD
signal calculate_happiness # HUD -> MAIN
signal delet_mess(object) #Object -> Main
signal rat_signal_l(rat : Object) # RAT -> HUD
signal rat_signal_r(rat : Object) # RAT -> HUD
signal ok_pressed() #name_edit -> HUD
signal no_pressed() #name_edit -> HUD

func _ready():
	pass 

