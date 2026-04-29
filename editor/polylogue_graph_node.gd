@tool

extends GraphNode
class_name PolylogueGraphNode

@export var conversation_node: PolylogueNodeBase

func _init(_conversation_node: PolylogueNodeBase):
	conversation_node = _conversation_node
	
	title = conversation_node.get_script().get_global_name()
	position_offset = conversation_node.position
	
	var max = max(len(conversation_node.get_input_slots()), len(conversation_node.get_output_slots()))
	
	for i in range(max):
		var control = conversation_node.add_inline_controls(i)
		if control == null: control = Label.new()
		add_child(control)
		
	for i in len(conversation_node.get_input_slots()):
		if conversation_node.get_input_slots()[i] != -1: set_slot_enabled_left(i, true)
	for i in len(conversation_node.get_output_slots()):
		if conversation_node.get_output_slots()[i] != -1: set_slot_enabled_right(i, true)
		
	var custom_control = conversation_node.add_custom_controls(VBoxContainer.new())
	if custom_control != null:
		add_child(custom_control)
		

func save():
	conversation_node.set_position(position_offset)
