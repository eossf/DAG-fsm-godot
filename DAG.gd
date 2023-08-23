@icon("res://DAG.png")
class_name DAG extends Node

# warning-ignore:unused_signal
signal finished(next_state_name)

var json_dict = {}
var root_arr = []

func get_json_dict():
	return json_dict

func get_root_arr():
	root_arr = json_dict.root
	root_arr.sort_custom(_sort_layer)
	return root_arr

func _init(filePath: String):
	json_dict = load_json(filePath)

func load_json(filePath: String):
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
