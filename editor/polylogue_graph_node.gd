@tool

extends GraphNode
class_name PolylogueGraphNode

@export var conversation_node: PolylogueNodeBase

func set_conversation_node(_conversation_node: PolylogueNodeBase):
	conversation_node = _conversation_node
	var max = max(conversation_node.get_input_slots(), conversation_node.get_output_slots())
	
	for i in range(max):
		var control = Control.new()
		add_child(control)
