extends Node
class_name Reader

signal exited(reason: String)
signal node_ready(node: PolylogueNodeBase)
signal polylogue_signal_emitted(event_name: String, payload: Variant)
signal branch_requested(condition: String, payload: Variant)

@export var conversation: Conversation
@export var current_node_index: int
@export var running: bool = false


func start():
	if conversation == null:
		printerr("Start called with no conversation set")
		return
	
	if conversation.get_start_node_id() == 0:
		exit("Invalid starting node")
		return
	
	running = true
	current_node_index = conversation.get_start_node_id()
	advance()


func advance(input: Variant = null):
	# print(conversation.nodes[current_node_index].uid)
	var result: int = conversation.nodes[current_node_index].advance(input)
	if result == -1:
		printerr("advance failed to resolve")
	else:
		if conversation.nodes.has(result):
			current_node_index = result
		else:
			printerr("current node has advanced to node that doesnt exist: {0}".format([result]))
			print(current_node_index)
	process_new_node()
	


func process_new_node():
	var current_node: PolylogueNodeBase = conversation.nodes[current_node_index]
	if current_node is EndNode:
		exit("Hit Exit node")
		return
	elif current_node is BranchNode:
		branch_requested.emit(current_node.string_identifier, current_node.payload)
	elif current_node is SignalNode:
		polylogue_signal_emitted.emit(current_node.string_identifier, current_node.payload)
	
	if current_node.auto_advance():
		advance()
	else:
		node_ready.emit(conversation.nodes[current_node_index])


func exit(reason: String):
	running = false
	exited.emit(reason)
	
func set_conversation(_conversation: Conversation):
	exit("New Conversation set")
	conversation = _conversation
