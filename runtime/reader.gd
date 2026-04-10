extends Node
class_name Reader

signal exited(reason: String)
signal line_ready(character: Character, line: String)

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
	
	process_new_node()


func process_new_node():
	if current_node is LineNode:
		line_ready.emit(current_node.character, current_node.line)
	elif current_node is EndNode:
		exit("Hit Exit node")


func exit(reason: String):
	running = false
	print(reason)
	exited.emit(reason)
