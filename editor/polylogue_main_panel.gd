@tool

extends GraphEdit
class_name PolylogueMainPanel

var conversation: Conversation

@onready var label: Label = $DoNotDestroy/PanelContainer/Label

var exempt_from_clear = ["DoNotDestroy", "_connection_layer"]

func set_conversation(_conversation):
	conversation = _conversation
	redraw()
	
func redraw():
	clear()
	if conversation == null: return
	
	label.text = conversation.title
	
	for node in conversation.nodes.values():
		var graph_node = PolylogueGraphNode.new()
		graph_node.set_conversation_node(node)
		add_child(graph_node)
		print("Added node")
	
func clear():
	label.text = ""
	clear_connections()
	for child in get_children():
		if exempt_from_clear.has(child.name): continue
		child.free()
