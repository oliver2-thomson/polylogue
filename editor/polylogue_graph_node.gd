@tool

extends GraphNode
class_name PolylogueGraphNode

@export var conversation_node: PolylogueNodeBase

func set_conversation_node(_conversation_node: PolylogueNodeBase):
	conversation_node = _conversation_node
	
	title = conversation_node.get_script().get_global_name()
	
	var max = max(conversation_node.get_input_slots(), conversation_node.get_output_slots())
	
	for i in range(max):
		var control = Label.new()
		add_child(control)
		
	for i in range(conversation_node.get_input_slots()):
		set_slot_enabled_left(i, true)
	for i in range(conversation_node.get_output_slots()):
		set_slot_enabled_right(i, true)
