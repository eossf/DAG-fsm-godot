extends Object
# use DAG for managing Infinite State Machine

@export var dag_file : String = "res://dag_test.json"

var root:Array = []
var current:Array = ["idle"]

func back():
	if current.size() > 1:
		current.pop_back()
	var b = current[current.size()-1]
	if b != null:
		go(b)

func go(node_name_wanted:String):
	print(" >>>>>>>>>>>>>>>>>>> Want to Go to " + node_name_wanted + " <<<<<<<<<<<<<<<<<<<")
	var i = search_node(node_name_wanted)
	
	# node wanted exists?
	if i > -1:
		var j = search_node(current[current.size()-1])
		var asked_node = root[i]
		var current_node = root[j]
		var node_name = current[current.size()-1]
		
		# ask the same node name is not possible
		if node_name != node_name_wanted:
			
			# ask the same layer, switch from node layer to the asked one
			if asked_node.layer == current_node.layer:
				current[current.size()-1] = node_name_wanted
				print("switch to " + node_name_wanted)

			# add node_name_wanted
			else:
				current.push_back(node_name_wanted)
				print("push " + node_name_wanted)

func load_json():
	if dag_file == null or dag_file == "":
		print("Error: no dag file (json)")
	var dag = DAG.new(dag_file)
	root = dag.get_root_arr()

func inspect():
	print("INSPECTION OF ROOT name, layer, parent, children")
	for d in root:
		print(d.name + " " + str(d.layer) + " " + str(d.children))
	print("")
	print("INSPECTION OF CURRENT ")
	print(current)

func search_node(node_name):
	var i = 0
	var idx = -1
	for d in root:
		if d.name == node_name:
			idx=i
			break
		i += 1
	return idx

func _on_button_pressed():
	load_json()
	go("idle")

func _on_walk_pressed():
	go("walk")

func _on_run_10_pressed():
	go("run")

func _on_jump_20_pressed():
	go("jump")

func _on_attack_30_pressed():
	go("attack")

func _on_inspect_pressed():
	inspect()

func _on_back_pressed():
	back()
