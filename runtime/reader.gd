extends Node
class_name Reader

signal exited(reason: String)
signal node_ready(node: PolylogueNodeBase)
signal polylogue_signal_emitted(event_name: String, payload: Variant)

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
	print(current_node.uid)
	var result: int = current_node.advance(input)
	if result == -1:
		printerr("advance failed to resolve")
	else:
		if conversation.nodes.has(result):
			current_node = conversation.nodes[result]
		else:
			printerr("current node has advanced to node that doesnt exist: {0}".format([result]))
	process_new_node()
	


func process_new_node():
	if current_node is EndNode:
		exit("Hit Exit node")
	elif current_node is SignalNode:
		polylogue_signal_emitted.emit(current_node.signal_name, current_node.payload)
	
	if current_node.auto_advance():
		advance()
	else:
		node_ready.emit(current_node)


func exit(reason: String):
	running = false
	print(reason)
	exited.emit(reason)
