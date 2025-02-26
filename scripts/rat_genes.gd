
var  mutation_chance = 101

var color = Globalvariables.grey

var fluffy = {"fluffy" : false}
var size = {"size" : 0.5}



var DNA = [Globalvariables.body_base,Globalvariables.ears_base,Globalvariables.eyes_base,Globalvariables.legs_base
,Globalvariables.nose_base,Globalvariables.tail_base,Globalvariables.horns_base,Globalvariables.wings_base,Globalvariables.mouth_base
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
