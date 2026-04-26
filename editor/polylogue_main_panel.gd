@tool

extends GraphEdit
class_name PolylogueMainPanel

var conversation: Conversation
var nodes_dict: Dictionary[int, PolylogueGraphNode]

var is_panning := false
var last_mouse_pos := Vector2.ZERO

@onready var label: Label = $DoNotDestroy/PanelContainer/Label
@onready var node_selector: NodeSelector = $DoNotDestroy/NodeSelector


var exempt_from_clear = ["DoNotDestroy", "_connection_layer"]

func _ready() -> void:
	node_selector.hide()

func set_conversation(_conversation):
	conversation = _conversation
	redraw()
	
func redraw():
	save()
	
	clear()
	if conversation == null: return
	
	label.text = conversation.title
	
	for key in conversation.nodes:
		var node = PolylogueGraphNode.new(conversation.nodes[key])
		nodes_dict[key] = node
		add_child(node)
		node.conversation_node.request_redraw.connect(redraw)
		node.conversation_node.request_delete.connect(_delete_single_node)
		

	#print("Nodes: {0}".format([nodes]))
	#print("Comversation.Nodes: {0}".format([conversation.nodes]))
	for node in nodes_dict.keys():
		# print("node: {0} -> {1}".format([node, conversation.nodes.get(node)]))
		var connections = conversation.nodes.get(node).get_output_slots()
		for connection in range(len(connections)):
			if connections[connection] != -1 && nodes_dict.keys().has(connections[connection]):
				connect_node(nodes_dict[node].name, connection, nodes_dict[connections[connection]].name, 0)
	
func clear():
	label.text = ""
	clear_connections()
	nodes_dict.clear()
	for child in get_children():
		if exempt_from_clear.has(child.name): continue
		if child is PolylogueGraphNode:
			child.conversation_node.request_redraw.disconnect(redraw)
			child.conversation_node.request_delete.disconnect(_delete_single_node)
		child.queue_free()


func _on_node_selected(node: Node) -> void:
	if node is PolylogueGraphNode:
		if node.conversation_node.open_inspector_on_select():
			EditorInterface.edit_resource(node.conversation_node)
			# EditorInterface.edit_node(node)
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_S && event.is_command_or_control_pressed():
			redraw()
			
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			is_panning = event.pressed
			last_mouse_pos = event.position
			accept_event()
			
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			_on_popup_request(get_local_mouse_position())

	elif event is InputEventMouseMotion and is_panning:
		var delta: Vector2 = event.position - last_mouse_pos
		scroll_offset -= delta / zoom
		last_mouse_pos = event.position
		accept_event()

func _on_connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2) -> void:
	# create popup listing all classes
	node_selector.position = release_position
	node_selector.choose_node_to_spawn({
		"from_node": from_node,
		"from_port": from_port,
		"release_position": (release_position + scroll_offset) / zoom
	})


func _on_node_selector_node_chosen(node_key: String, state: Dictionary) -> void:
	var node = PolylogueInterface.instantiable_node_types.get(node_key)
	
	var node_index = conversation.add_node(node.new())
	var node_instance = conversation.nodes[node_index]
	
	node_instance.position = state.get("release_position")
	
	if state.keys().has("from_node"):
		var from_graph_node: PolylogueGraphNode = _get_graph_node_by_string_name(state.get("from_node"))
		var from_node_instance: PolylogueNodeBase = from_graph_node.conversation_node
		from_node_instance.set_output_slot(state.get("from_port"), node_index)

	redraw()
	
# Make this more optimised later
func _get_graph_node_by_string_name(from_node: StringName) -> PolylogueGraphNode:
	var nodes_in_graph = get_children()
	for node in nodes_in_graph:
		if node.name == from_node:
			return node
	printerr("Graph node not found: {0}".format([from_node]))
	return null


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	var from_graph_node = _get_graph_node_by_string_name(from_node)
	var to_graph_node = _get_graph_node_by_string_name(to_node)
	
	from_graph_node.conversation_node.output_slots[from_port] = to_graph_node.conversation_node.uid
	
	redraw()
	
func save():
	if !conversation: return
	for node in nodes_dict.values():
		node.save()
	conversation.save()


func _on_node_deselected(node: Node) -> void:
	if node is PolylogueGraphNode:
		if node.conversation_node.open_inspector_on_select():
			EditorInterface.edit_node(null)

func _delete_single_node(_uid: int):
	var node_string_name = ""
	for node in nodes_dict.values():
		if node is PolylogueGraphNode:
			if node.conversation_node.uid == _uid:
				node_string_name = node.name
				break
	
	if node_string_name != "":
		_on_delete_nodes_request([node_string_name])

func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	# print("Deleting {0} nodes".format([len(nodes)]))
	for deleted_node in nodes:
		var deleted_graph_node = _get_graph_node_by_string_name(deleted_node)
		if deleted_graph_node.conversation_node is StartNode: return
		var connections_list := get_connection_list_from_node(deleted_node)
		for connection in connections_list:
			if connection.get("to_node") == deleted_node:
				var from_graph_node = _get_graph_node_by_string_name(connection.get("from_node"))
				if from_graph_node:
					from_graph_node.conversation_node.set_output_slot(connection.get("from_port"), 0)
		conversation.remove_node(deleted_graph_node.conversation_node.uid)
	redraw()
					




func _on_popup_request(at_position: Vector2) -> void:
	print("Popup requested at:" + str(at_position))
	node_selector.position = at_position
	node_selector.choose_node_to_spawn({
		"release_position": (at_position + scroll_offset) / zoom
	})
