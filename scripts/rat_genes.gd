
var  mutation_chance = 101

var color = GlobalFuncNVar.grey

var fluffy = {"fluffy" : false}
var size = {"size" : 0.5}



var DNA = [GlobalFuncNVar.body_base,GlobalFuncNVar.ears_base,GlobalFuncNVar.eyes_base,GlobalFuncNVar.legs_base
,GlobalFuncNVar.nose_base,GlobalFuncNVar.tail_base,GlobalFuncNVar.horns_base,GlobalFuncNVar.wings_base,GlobalFuncNVar.mouth_base
]

func get_fluffy():
	return fluffy["fluffy"]
	
func get_size():
	return size["size"]
	
func set_fluffy(value : bool):
	if value is bool: 
		fluffy["fluffy"] = value
		return 0
	return -1

func return_genes_array()-> Array:
	var arr : Array = []
	arr.append_array(DNA)
	arr.append(size)
	arr.append(fluffy)
	arr.append(color)
	return arr
