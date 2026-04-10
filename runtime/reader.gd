extends Node
class_name Reader

signal exited(reason: String)
signal node_ready(node: PolylogueNodeBase)

@export var conversation: Conversation
@export var current_node: PolylogueNodeBase
@export var running: bool = false


func start():
	if conversation.start_node_id == 0:
		exit("Invalid starting node")
		return
	
	running = true
	current_node = conversation.nodes[conversation.start_node_id]
	progress()


func progress():
	if current_node is SingleNextNode:
		current_node = conversation.nodes[current_node.next_id]
		if current_node == null:
			exit("Encountered invalid node")
			return
	else:
		printerr("progress called on node that does not inherit from SingleNextNode")
	
	process_new_node()
	
func choose_option(option: int):
	if current_node is OptionNode:
		var option_chosen: BranchOption = current_node.options[option]
		if option_chosen != null:
			current_node = conversation.nodes[option_chosen.next_id]
		else:
			printerr("Option out of bounds chosen")
	else:
		printerr("choose_option called on node that does not inherit from OptionNode")
		
	process_new_node()

func process_new_node():
	if current_node is EndNode:
		exit("Hit Exit node")
	else:
		node_ready.emit(current_node)


func exit(reason: String):
	running = false
	print(reason)
	exited.emit(reason)
