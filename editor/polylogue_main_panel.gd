@tool

extends GraphEdit
class_name PolylogueMainPanel

var conversation: Conversation
var nodes: Dictionary[int, PolylogueGraphNode]

@onready var label: Label = $DoNotDestroy/PanelContainer/Label
@onready var node_selector: NodeSelector = $DoNotDestroy/NodeSelector


var exempt_from_clear = ["DoNotDestroy", "_connection_layer"]

func _ready() -> void:
	node_selector.hide()

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
		var connections = conversation.nodes.get(node).get_output_slots()
		for connection in range(len(connections)):
			if connections[connection] != -1 && nodes.keys().has(connections[connection]):
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


func _on_connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2) -> void:
	# create popup listing all classes
	node_selector.position = release_position
	node_selector.choose_node_to_spawn({
		"from_node": from_node,
		"from_port": from_port,
		"release_position": release_position
	})


func _on_node_selector_node_chosen(node_key: String, state: Dictionary) -> void:
	var node = PolylogueInterface.instantiable_node_types.get(node_key)
	
	print(state)
	
	var node_index = conversation.add_node(node.new())
	var node_instance = conversation.nodes[node_index]
	
	node_instance.position = state.get("release_position")
	
	var from_graph_node: PolylogueGraphNode
	
	var nodes_in_graph = get_children()
	for node_in_graph in nodes_in_graph:
		if node_in_graph.name == state.get("from_node"):
			from_graph_node = node_in_graph
			var from_node_instance: PolylogueNodeBase = from_graph_node.conversation_node
			from_node_instance.set_output_slot(state.get("from_port"), node_index)
	
	redraw()
	
	
