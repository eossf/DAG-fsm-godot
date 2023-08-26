extends Object
# use DAG for managing Infinite State Machine

signal request_turn_left
signal request_turn_right

@export var dag_file : String = "res://dag_test.json"

var root_node:Array = []
var current_node:Array = []
var current_direction:String = "right"

func _turn(direction:String):
	current_direction = direction

func _back():
	if current_node.size() > 1:
		current_node.pop_back()
	if current_node.size() > 0:
		_go(current_node[current_node.size()-1].name)

func _go(node_name_wanted:String):
	print(" >>>>>>>>>>>>>>>>>>> Want to Go to " + node_name_wanted + " <<<<<<<<<<<<<<<<<<<")
	var i = _search_node(node_name_wanted)
	# node wanted exists?
	if i > -1:
		var node_wanted = root_node[i]
		var node_ongoing = current_node[current_node.size()-1]
		var node_name = node_ongoing.name
		
		# ask the same node name is not possible
		if node_name != node_name_wanted:
			
			# ask the same layer, switch from node layer to the asked one
			if node_wanted.layer == node_ongoing.layer:
				current_node[current_node.size()-1] = node_wanted
				print("switch to " + node_name_wanted)
			else:
				# impossible to push for this case
				if node_wanted.layer < node_ongoing.layer:
					print("impossible for layer under current ")
				
				# add node_name_wanted
				else:
					current_node.push_back(node_wanted)
					print("push " + node_name_wanted)

func _load_json():
	if dag_file == null or dag_file == "":
		print("Error: no dag file (json)")
	var dag = DAG.new(dag_file)
	root_node = dag.getRoot()

func _init_dag():
	# get first node from DAG
	current_node.clear()
	current_node.push_back(root_node[0])

func _inspect():
	print("INSPECTION OF ROOT name, layer, parent, children")
	for d in root_node:
		print(d.name + " " + str(d.layer) + " " + str(d.children))
	print("")
	print("INSPECTION OF CURRENT ")
	print("Direction :" + current_direction)
	for d in current_node:
		print(d.name + " " + str(d.layer) + " " + str(d.children))

func _search_node(searched_node_name:String):
	var i = 0
	var idx = -1
	for entry in root_node:
		if entry.name == searched_node_name:
			idx=i
			break
		i += 1
	return idx

# HERE starting point
func _on_button_pressed():
	_load_json()
	_init_dag()
	_go("idle")

func _on_walk_pressed():
	_go("walk")

func _on_run_10_pressed():
	_go("run")

func _on_jump_20_pressed():
	_go("jump")

func _on_attack_30_pressed():
	_go("attack")

func _on_inspect_pressed():
	_inspect()

func _on_back_pressed():
	_back()

func _on_direction_pressed():
	if current_direction == "right":
		_turn("left")
		emit_signal("request_turn_left")
	else:
		_turn("right")
		emit_signal("request_turn_right")

# --------------------- LISTENING SIGNALS ---------------------

func _on_player_go_left():
	_turn("left")

func _on_player_go_right():
	_turn("right")
