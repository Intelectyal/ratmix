extends Node

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

var body_parts_dic = {0:"bodys",1:"legs",2:"tails",3:"eyes",4:"ears",5:"noses"}
var FoodTime : float = 187.0
var rats_arr : Array
var screen_size 
var rat_on_path : bool
var money : int 
var FirstName : Array
var SecondName : Array
var Brush = null
var Brush_cursor : Resource
var food : int
var max_rats : int
var can_buy_rat : bool
var shelf_is_buy : bool
var objs_list = {"Wheel":false,"Bush":false,"Tramp":false,"Tube":false,"House":false}
var objs_coord = {"Wheel":Vector2(1728,904),"Bush":Vector2(328,936),"Tramp":Vector2(176,728),"Tube":Vector2(1536,648),"House":Vector2(1784,584)}


var ears_base = {
	"fur" : "res://art/rat/ears/tier0/0fur.png",
	"skin" : "res://art/rat/ears/tier0/0skin.png"
}
var ears_tier1_1 = {
	"fur" : "res://art/rat/ears/tier1/1fur.png",
	"skin" : "res://art/rat/ears/tier1/1skin.png"
}
var ears_tier1_2 = {
	"fur" : "res://art/rat/ears/tier1/2fur.png",
	"skin" : "res://art/rat/ears/tier1/2skin.png"
}
var ears_tier1_3 = {
	"fur" : "res://art/rat/ears/tier1/3fur.png",
	"skin" : "res://art/rat/ears/tier1/3skin.png"
}

var ears_tier2_1 = {
	"fur" : "res://art/rat/ears/tier2/1fur.png",
	"skin" : "res://art/rat/ears/tier2/1skin.png"
}
var ears_tier2_2 = {
	"fur" : "res://art/rat/ears/tier2/2fur.png",
	"skin" : "res://art/rat/ears/tier2/2skin.png"
}

var eyes_base = {
	"skin" : "res://art/rat/eyes/tier0/0.png"
}
var eyes_tier1_1 = {
	"skin" : "res://art/rat/eyes/tier1/1.png"
}
var eyes_tier1_2 = {
	"skin" : "res://art/rat/eyes/tier1/2.png"
}

var eyes_tier2_1 = {
	"skin" : "res://art/rat/eyes/tier2/1.png"
}
var eyes_tier2_2 = {
	"skin" : ""
}
var legs_base = {
	"skin" : "res://art/rat/legs/tier0/0skin.png",
	"fur" : "res://art/rat/legs/tier0/0fur.png"
}
var legs_tier1_1 = {
	"skin" : "res://art/rat/legs/tier1/1skin.png",
	"fur" : "res://art/rat/legs/tier1/1fur.png"
}
var legs_tier1_2 = {
	"skin" : "res://art/rat/legs/tier1/2skin.png",
	"fur" : "res://art/rat/legs/tier1/2fur.png"
}

var legs_tier1_3 = {
	"skin" : "res://art/rat/legs/tier1/3skin.png",
	"fur" : "res://art/rat/legs/tier1/3fur.png"
}
var legs_tier2_1 = {
	"skin" : "res://art/rat/legs/tier2/1skin.png",
	"fur" : "res://art/rat/legs/tier2/1fur.png"
}
var legs_tier2_2 = {
	"skin" : "res://art/rat/legs/tier2/2skin.png",
	"fur" : "res://art/rat/legs/tier2/2fur.png"
}
var nose_base = {
	"fur" : "",
	"skin" : "res://art/rat/noses/tier0/0skin.png"
}
var nose_tier1_1 = {
	"fur" : "res://art/rat/noses/tier1/1fur.png",
	"skin" : "res://art/rat/noses/tier1/1skin.png"
}
var nose_tier2_1 = {
	"fur" :  "res://art/rat/noses/tier2/1fur.png",
	"skin" : "res://art/rat/noses/tier2/1skin.png"
}

var tail_base = {
	"fur" : "res://art/rat/tails/tier0/0fur.png",
	"skin" : "res://art/rat/tails/tier0/0skin.png"
}
var tail_tier1_1 = {
	"fur" : "res://art/rat/tails/tier1/1fur.png",
	"skin" : "res://art/rat/tails/tier1/1skin.png"
}
var tail_tier1_2 = {
	"fur" : "res://art/rat/tails/tier1/2fur.png",
	"skin" : "res://art/rat/tails/tier1/2skin.png"
}
var tail_tier1_3 = {
	"fur" : "res://art/rat/tails/tier1/3fur.png",
	"skin" : "res://art/rat/tails/tier1/3skin.png"
}
var tail_tier2_1 = {
	"fur" : "res://art/rat/tails/tier2/1fur.png",
	"skin" : "res://art/rat/tails/tier2/1skin.png"
}
var tail_tier2_2 = {
	"fur" : "",
	"skin" : ""
}
var body_base = {
	"fur" : "res://art/rat/bodys/tier0/0.png"
}
var body_fluffy = {
	"fur" : "res://art/rat/bodys/tier0/1.png"
}
var spots = {
	"fur" : "res://art/rat/over/tier1/1.png"
}

var grey = { #серый
	"summable": [],
	"value": Color("7e7e8f"),
	"spots": false
}

var light_grey = { #светло-серый
	"summable": [],
	"value": Color.GRAY,
	"spots": false
}

var black = { #черный
	"summable": [],
	"value": Color.BLACK,
	"spots": false 
}

var brown = { #коричневый
	"summable": [],
	"value": Color.SADDLE_BROWN,
	"spots": false
}
var semi_bald = { #полу лысый
	"summable": [],
	"value": Color.PINK,
	"spots": true, 
	"value_s": Color("7e7e8f")
}

var white = { #белый
	"summable": [],
	"value": Color.WHITE,
	"spots": false
}

var blue = { #синий
	"summable": [],
	"value": Color.BLUE,
	"spots": false
}

var red = { #рыжий
	"summable": [],
	"value": Color.ORANGE,
	"spots": false
}

var bald = { #лысый
	"summable": [],
	"value": Color.PINK,
	"spots": false
}

var yellow = { #желтый
	"summable": [],
	"value": Color.YELLOW,
	"spots": false
}

var burgundy = { #красный
	"summable": [],
	"value": Color.CRIMSON,
	"spots": false
}

var black_w = { #черно-белый
	"summable": [],
	"value": Color.BLACK,
	"spots": true,
	"value_s": Color.WHITE
}

var brown_w = { # коричнево-белый
	"summable": [],
	"value": Color.SADDLE_BROWN,
	"spots": true,
	"value_s": Color.WHITE
}

var black_r = { #черно-рыжий
	"summable": [],
	"value": Color.BLACK,
	"spots": true,
	"value_s": Color.ORANGE
}

var pink = { #розовый
	"summable": [],
	"value": Color.HOT_PINK,
	"spots": false
}

var green = { #зеленый
	"summable": [],
	"value": Color.GREEN,
	"spots": false
}

var violet = { #фиолетовый
	"summable": [],
	"value": Color.VIOLET,
	"spots": false
}

func _ready():
	ears_base["neighb"] = [ears_tier1_1,ears_tier1_2,ears_tier1_3]
	ears_tier1_1["neighb"] = [ears_tier2_1,ears_tier2_2]
	ears_tier1_2["neighb"] = [ears_tier2_1,ears_tier2_2]
	ears_tier1_3["neighb"] = [ears_tier2_1,ears_tier2_2]
	eyes_base["neighb"] = [eyes_tier1_1,eyes_tier1_2]
	eyes_tier1_1["neighb"] = [eyes_tier2_1]
	eyes_tier1_2["neighb"] = [eyes_tier2_2]
	legs_base["neighb"] = [legs_tier1_1,legs_tier1_2,legs_tier1_3]
	legs_tier1_1["neighb"] =[legs_tier2_2]
	legs_tier1_2["neighb"] = [legs_tier2_1]
	legs_tier1_3["neighb"] = [legs_tier2_1]
	nose_base["neighb"] = [nose_tier1_1]
	nose_tier1_1["neighb"] = [nose_tier2_1]
	tail_base["neighb"] = [tail_tier1_1,tail_tier1_2,tail_tier1_3]
	tail_tier1_1["neighb"] = [tail_tier2_1]
	tail_tier1_2["neighb"] = [tail_tier2_2]
	
	grey["neighb"] = [light_grey,black,brown,semi_bald]
	light_grey["neighb"] = [white]
	black["neighb"] = [blue]
	brown["neighb"] = [red]
	semi_bald["neighb"] = [bald]
	white["neighb"] = [yellow]	
	red["neighb"] = [burgundy]
	
	black["summable"] = [black_w, black_r]
	brown["summable"] = [brown_w]
	white["summable"] = [black_w, brown_w, pink]
	red["summable"] = [black_r]
	blue["summable"] = [green, violet]
	yellow["summable"] = [green]	
	burgundy["summable"] = [pink,violet]
	
	food = 0
	can_buy_rat = true
	max_rats = 16
	rat_on_path = false
	shelf_is_buy = false
	
	var file = FileAccess.open("res://etc/first.txt",FileAccess.READ).get_file_as_string("res://etc/first.txt")
	get_txt(file, FirstName)
	file = FileAccess.open("res://etc/first.txt",FileAccess.READ).get_file_as_string("res://etc/second.txt")
	get_txt(file, SecondName)
	Brush_cursor = load("res://art/object2/Без имени-2.png")

func get_txt(mystr : String, arr : Array):
	var b = mystr.count("\n")
	for i in b:
		arr.append("")
	var i = 0 
	var n = 0
	while i < (mystr.length()-6):
		while mystr[i] != "\r":
			arr[n] += mystr[i]
			i += 1
		n += 1
		i += 1
	for c in arr.size():
		arr[c] = arr[c].replace("\n","")



func _process(delta):
	pass

func roulette(chance):
	var mutation_prob = 20-chance
	var inheritance:int = mutation_prob/2
	var a = randi_range(1,20)
	if a > mutation_prob:
		return 2
	elif a <= inheritance:
		return 0#<- 0
	else:
		return 1 
