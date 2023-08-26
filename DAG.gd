@icon("res://DAG_128x128.png")
class_name DAG extends Object

# warning-ignore:unused_signal
signal finished(next_state_name)

var json:
	get = getJson, set = setJson

var root:
	get = getRoot, set = setRoot

var direction:
	get = getDirection, set = setDirection

func getDirection():
	return direction

func setDirection(d:String):
	direction = d

func setJson(j:Dictionary):
	json = j

func getJson():
	return json

func setRoot(a:Array):
	root = a

# get root mandatory states
func getRoot():
	root = json.root.states
	root.sort_custom(_sort_layer)
	return root

func _init(filePath: String):
	json = _load_json(filePath)

func _load_json(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedData = JSON.parse_string(dataFile.get_as_text())
		if parsedData is Dictionary:
			return parsedData
		else:
			print("Error: parsing " + filePath + " is not a regular JSON")
	else:
		print("Error: File " + filePath + " not found")

func _sort_layer(a, b):
	if a["layer"] < b["layer"]:
		return true
	return false
