@tool
extends EditorPlugin
class_name PolylogueInterface

const MainPanel = preload("res://addons/polylogue/editor/polylogue_main_panel.tscn")

var main_panel_instance: PolylogueMainPanel
static var instantiable_node_types: Dictionary = {}
var global_class_list: Array[Dictionary] = []

func _enable_plugin() -> void:
	EditorInterface.get_resource_filesystem().script_classes_updated.connect(_update_instantiable_node_types)
	_update_instantiable_node_types()

func _disable_plugin() -> void:
	EditorInterface.get_resource_filesystem().script_classes_updated.disconnect(_update_instantiable_node_types)


func _enter_tree() -> void:
	main_panel_instance = MainPanel.instantiate()
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	_make_visible(false)


func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _get_plugin_name():
	return "Polylogue"


func _get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")

func _handles(object: Object) -> bool:
	return object is Conversation
	
func _edit(object: Object) -> void:
	if object is Conversation:
		main_panel_instance.set_conversation(object)
		_make_visible(true)
		print(object.resource_path)

func _update_instantiable_node_types():
	#print("Reloading node based types")
	instantiable_node_types = {}
	global_class_list= ProjectSettings.get_global_class_list()
	for dict in global_class_list:
		if _test_if_derivitive_of_class(dict, "PolylogueNodeBase"):
			instantiable_node_types[dict.get("class")] = load(dict.get("path"))
	#print("{0} PolylogueNodeBase derivatives".format([instantiable_node_types.size()]))
	#print(instantiable_node_types.keys())
	
	
func _test_if_derivitive_of_class(test_class: Dictionary, base_class: String) -> bool:	
	var base: String = test_class.get("base")
	
	if base == base_class: return true
	
	for entry in global_class_list:
		if entry.get("class") == base:
			return _test_if_derivitive_of_class(entry, base_class)
	
	return false
	
	
