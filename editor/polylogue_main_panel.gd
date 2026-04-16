@tool

extends GraphEdit
class_name PolylogueMainPanel

var conversation: Conversation
var nodes: Dictionary[int, PolylogueGraphNode]

@onready var label: Label = $DoNotDestroy/PanelContainer/Label

var exempt_from_clear = ["DoNotDestroy", "_connection_layer"]

func set_conversation(_conversation):
	conversation = _conversation
	redraw()
	
func redraw():
	clear()
	if conversation == null: return
	
	label.text = conversation.title
	
	for key in conversation.nodes:
		var node = PolylogueGraphNode.new(conversation.nodes[key])
		nodes[key] = node
		add_child(node)
		
		
	for node in nodes.keys():
		var connections = conversation.nodes[node].get_output_destinations()
		for connection in range(len(connections)):
			if connections[connection] != -1:
				connect_node(nodes[node].name, connection, nodes[connections[connection]].name, 0)

func clear():
	label.text = ""
	clear_connections()
	for child in get_children():
		if exempt_from_clear.has(child.name): continue
		child.free()


func _on_node_selected(node: Node) -> void:
	if node is PolylogueGraphNode:
		EditorInterface.edit_resource(node.conversation_node)
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_S && event.is_command_or_control_pressed():
			for node in nodes.values():
				node.save()
