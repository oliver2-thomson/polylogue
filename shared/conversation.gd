extends Resource
class_name Conversation

@export_group("Metadata")
@export var title: String
@export var start_node_id: String
@export var node_positions: Dictionary[int, Vector2]

@export_group("")
@export var nodes: Dictionary[int, PolylogueNodeBase]

func add_node(node: PolylogueNodeBase):
	var id: int = ResourceUID.create_id()
	
	# Ensure no conflicting UUIDs since we are not registering.
	while nodes.has(id):
		id = ResourceUID.create_id()
	
	node.set_uid(id)
	nodes[id] = node
