@tool

extends Resource
class_name Conversation

@export_group("Metadata")
@export var title: String
@export var start_node_id: int

@export_group("")
@export var nodes: Dictionary[int, PolylogueNodeBase]

func _init() -> void:
	if nodes.size() > 0: return # Early return for conversations that have already been initialised
	
	var new_node = StartNode.new()
	start_node_id = add_node(new_node)

func add_node(node: PolylogueNodeBase) -> int:
	var id: int = ResourceUID.create_id()
	
	# Ensure no conflicting UUIDs since we are not registering.
	while nodes.has(id):
		id = ResourceUID.create_id()
	
	node.set_uid(id)
	nodes[id] = node
	return id
