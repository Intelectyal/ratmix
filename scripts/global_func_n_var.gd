extends Node



var discovered_genes : Array = []
var FoodTime : float = 180.0
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
var HudFlag : bool = true #нужен для отключения взаимодействия с крысами, когда пользователь взаимодействует с элементами HUD



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
var eyes_tier3_1 = { #заполнить
	"skin" : "res://art/rat/eyes/tier3/1.png"
}
var eyes_tier2_1 = {
	"skin" : "res://art/rat/eyes/tier2/1.png"
}
var eyes_tier2_2 = {
	"skin" : "res://art/rat/eyes/tier2/2null"
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
	"fur" : "res://art/rat/noses/tier0/0null",
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
var nose_tier1_2 = { 	
	"fur" :  "res://art/rat/noses/tier2/2null",
	"skin" : "res://art/rat/noses/tier2/2skin.png"
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
	"fur" : "res://art/rat/tails/tier2/2null",
	"skin" : "res://art/rat/tails/tier2/2null"
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

var mouth_base = {
	"fur" : "res://art/rat/mouth/tier0/0null",
	"skin" : "res://art/rat/mouth/tier0/0null"
}
var horns_base = {
	"fur" : "res://art/rat/horns/tier0/0null",
	"skin" : "res://art/rat/horns/tier0/0null"
}
var wings_base = {
	"fur" : "res://art/rat/wings/tier0/0null",
	"skin" : "res://art/rat/wings/tier0/0null"
}
var mouth_tier1_1 = {
	"fur" : "res://art/rat/mouth/tier1/1null",
	"skin" : "res://art/rat/mouth/tier1/1.png"
}
var mouth_tier2_1= {
	"fur" : "res://art/rat/mouth/tier2/1null",
	"skin" : "res://art/rat/mouth/tier2/1.png"
}
var horns_tier1_1= {
	"fur" : "res://art/rat/horns/tier1/1null",
	"skin" : "res://art/rat/horns/tier1/1.png"
}
var horns_tier2_1= {
	"fur" : "res://art/rat/horns/tier2/1null",
	"skin" : "res://art/rat/horns/tier2/1.png"
}
var horns_tier2_2= {
	"fur" : "res://art/rat/horns/tier2/2null",
	"skin" : "res://art/rat/horns/tier2/2.png"
}
var wings_tier1_1 = {
	"fur" : "res://art/rat/wings/tier1/1null",
	"skin" : "res://art/rat/wings/tier1/1.png"
}
var wings_tier2_1 = {
	"fur" : "res://art/rat/wings/tier2/1null",
	"skin" : "res://art/rat/wings/tier2/1.png"
}
#var mouth_tier1_1 = {}
#var mouth_tier2_1= {}
#var horns_tier1_1= {}
#var horns_tier2_1= {}
#var horns_tier2_2= {}
#var wings_tier1_1 = {}
#var wings_tier2_1 = {}

var grey = { #серый
	"summable": false,
	"value": Color("7e7e8f"),
	"spots": false,
	"neighb" : []
}

var light_grey = { #светло-серый
	"summable": false,
	"value": Color.GRAY,
	"spots": false,
	"neighb" : []
}

var black = { #черный
	"summable": false,
	"value": Color.BLACK,
	"spots": false ,
	"neighb" : []
}

var brown = { #коричневый
	"summable": false,
	"value": Color.SADDLE_BROWN,
	"spots": false,
	"neighb" : []
}
var semi_bald = { #полу лысый
	"summable": false,
	"value": Color.PINK,
	"spots": true, 
	"value_s": Color("7e7e8f"),
	"neighb" : []
}

var white = { #белый
	"summable": false,
	"value": Color.WHITE,
	"spots": false,
	"neighb" : []
}

var blue = { #синий
	"summable": false,
	"value": Color.BLUE,
	"spots": false,
	"neighb" : []
}

var red = { #рыжий
	"summable": false,
	"value": Color.ORANGE,
	"spots": false,
	"neighb" : []
}

var bald = { #лысый
	"summable": false,
	"value": Color.PINK,
	"spots": false,
	"neighb" : []
}

var yellow = { #желтый
	"summable": false,
	"value": Color.YELLOW,
	"spots": false,
	"neighb" : []
}

var burgundy = { #красный
	"summable": false,
	"value": Color.CRIMSON,
	"spots": false,
	"neighb" : []
}

var black_w = { #черно-белый
	"summable": true,
	"value": Color.BLACK,
	"spots": true,
	"value_s": Color.WHITE,
	"neighb" : []
}

var brown_w = { # коричнево-белый
	"summable": true,
	"value": Color.SADDLE_BROWN,
	"spots": true,
	"value_s": Color.WHITE,
	"neighb" : []
}

var black_r = { #черно-рыжий
	"summable": true,
	"value": Color.BLACK,
	"spots": true,
	"value_s": Color.ORANGE,
	"neighb" : []
}

var pink = { #розовый
	"summable": true,
	"value": Color.HOT_PINK,
	"spots": false,
	"neighb" : []
}

var green = { #зеленый
	"summable": true,
	"value": Color.GREEN,
	"spots": false,
	"neighb" : []
}

var violet = { #фиолетовый
	"summable": true,
	"value": Color.VIOLET,
	"spots": false,
	"neighb" : []
}

func _ready():
	ears_base["neighb"] = [ears_tier1_1,ears_tier1_2,ears_tier1_3]
	ears_tier1_1["neighb"] = [ears_tier2_1,ears_tier2_2]
	ears_tier1_2["neighb"] = [ears_tier2_1,ears_tier2_2]
	ears_tier1_3["neighb"] = [ears_tier2_1,ears_tier2_2]
	eyes_base["neighb"] = [eyes_tier1_1,eyes_tier1_2]
	eyes_tier1_1["neighb"] = [eyes_tier2_1]
	eyes_tier1_2["neighb"] = [eyes_tier2_2]
	eyes_tier2_1["neighb"] = [eyes_tier3_1]
	legs_base["neighb"] = [legs_tier1_1,legs_tier1_2,legs_tier1_3]
	legs_tier1_1["neighb"] =[legs_tier2_2]
	legs_tier1_2["neighb"] = [legs_tier2_1]
	legs_tier1_3["neighb"] = [legs_tier2_1]
	nose_base["neighb"] = [nose_tier1_1,nose_tier1_2]
	nose_tier1_1["neighb"] = [nose_tier2_1]
	tail_base["neighb"] = [tail_tier1_1,tail_tier1_2,tail_tier1_3]
	tail_tier1_1["neighb"] = [tail_tier2_1]
	tail_tier1_2["neighb"] = [tail_tier2_2]
	
	
	mouth_base["neighb"] = [mouth_tier1_1]
	mouth_tier1_1["neighb"] = [mouth_tier2_1]
	horns_base["neighb"] = [horns_tier1_1]
	horns_tier1_1["neighb"] = [horns_tier2_1,horns_tier2_2]
	wings_base["neighb"] = [wings_tier1_1]
	wings_tier1_1["neighb"] = [wings_tier2_1]
	
	grey["neighb"] = [light_grey,black,brown,semi_bald]
	light_grey["neighb"] = [white]
	black["neighb"] = [blue,black_w,black_r]
	brown["neighb"] = [red,brown_w]
	semi_bald["neighb"] = [bald]
	white["neighb"] = [yellow,black_w,brown_w,pink]	
	red["neighb"] = [burgundy,black_r]
	blue["neighb"] = [green, violet]
	yellow["neighb"] = [green]
	burgundy["neighb"] = [pink,violet]
	
	black_w["neighb"] = []
	black_r["neighb"]= []
	brown_w["neighb"]= []
	pink["neighb"]= []
	green["neighb"]= []
	violet["neighb"]= []
	
	food = 0
	can_buy_rat = true
	max_rats = 16
	rat_on_path = false
	shelf_is_buy = false
	
	var file = FileAccess.open("res://etc/first.txt",FileAccess.READ).get_file_as_string("res://etc/first.txt")
	get_txt(file, FirstName)
	file = FileAccess.open("res://etc/first.txt",FileAccess.READ).get_file_as_string("res://etc/second.txt")
	get_txt(file, SecondName)
	Brush_cursor = load("res://art/object2/brush_cursor.png")

func get_txt(mystr : String, arr : Array):
	var b = mystr.count("\n")
	for i in b:
		arr.append("")
	var i = 0 
	var n = 0
	while i < (mystr.length()-6):
		while mystr[i] != "\n": #ХЗ почему но на рабочем компе пкрашится. i = 282 и выходит за массив, если не исправить на "\n" 
			arr[n] += mystr[i]
			i += 1
		n += 1
		i += 1
	for c in arr.size(): #БТВ к тому же нужен этот кусок кода не нужен на рабочем компе. Возможно дело в версиях годота 4.1.2 дома
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
