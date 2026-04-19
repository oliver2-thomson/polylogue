extends Node
class_name Reader

signal exited(reason: String)
signal node_ready(node: PolylogueNodeBase)
signal polylogue_signal_emitted(event_name: String, payload: Variant)

@export var conversation: Conversation
@export var current_node: int
@export var running: bool = false


func start():
	if conversation.start_node_id == 0:
		exit("Invalid starting node")
		return
	
	running = true
	current_node = conversation.start_node_id
	advance()


func advance(input: Variant = null):
	print(conversation.nodes[current_node].uid)
	var result: int = conversation.nodes[current_node].advance(input)
	if result == -1:
		printerr("advance failed to resolve")
	else:
		if conversation.nodes.has(result):
			current_node = result
		else:
			printerr("current node has advanced to node that doesnt exist: {0}".format([result]))
			print(current_node)
	process_new_node()
	


func process_new_node():
	if conversation.nodes[current_node] is EndNode:
		exit("Hit Exit node")
	elif conversation.nodes[current_node] is SignalNode:
		polylogue_signal_emitted.emit(conversation.nodes[current_node].signal_name, conversation.nodes[current_node].payload)
	
	if conversation.nodes[current_node].auto_advance():
		advance()
	else:
		node_ready.emit(conversation.nodes[current_node])


func exit(reason: String):
	running = false
	print(reason)
	exited.emit(reason)
