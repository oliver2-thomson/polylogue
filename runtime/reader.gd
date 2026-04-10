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
	advance()


func advance(input: Variant = null):
	var result: int = current_node.advance(input)
	if result == -1:
		printerr("advance failed to resolve")
	else:
		current_node = conversation.nodes[result]
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
