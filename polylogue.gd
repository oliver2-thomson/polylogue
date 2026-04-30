@tool
extends EditorPlugin
class_name PolylogueInterface

const MainPanel = preload("res://addons/polylogue/editor/polylogue_main_panel.tscn")

var main_panel_instance: PolylogueMainPanel
static var instantiable_node_types: Dictionary = {}

const TEMPLATE_SOURCE := "res://addons/polylogue/templates/script_templates"
const TEMPLATE_TARGET := "res://script_templates"

func _enable_plugin() -> void:
	pass

func _disable_plugin() -> void:
	pass


func _enter_tree() -> void:
	_install_script_templates()
	main_panel_instance = MainPanel.instantiate()
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	_make_visible(false)
	
	EditorInterface.get_resource_filesystem().script_classes_updated.connect(_update_instantiable_node_types)
	_update_instantiable_node_types()
	
	var action := "ui_graph_delete"

	if InputMap.has_action(action):
		var backspace_event := InputEventKey.new()
		backspace_event.keycode = KEY_BACKSPACE

		# Avoid duplicate bindings
		if not InputMap.action_has_event(action, backspace_event):
			InputMap.action_add_event(action, backspace_event)


func _exit_tree() -> void:
	EditorInterface.get_resource_filesystem().script_classes_updated.disconnect(_update_instantiable_node_types)
	
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

func _update_instantiable_node_types():
	instantiable_node_types = {}
	var target_class: Script = preload("res://addons/polylogue/shared/nodes/polylogue_node_base.gd")
	var global_class_list: Array[Dictionary] = ProjectSettings.get_global_class_list()
	for dict in global_class_list:
		var script: Script = load(dict.get("path"))
		if !script.is_abstract():
			if _test_if_derivitive_of_class(script, target_class):
				instantiable_node_types[dict.get("class")] = script
	
func _test_if_derivitive_of_class(test_class: Script, target_class: Script) -> bool:	
	if test_class == target_class: return true
	
	var base_script: Script = test_class.get_base_script()
	if base_script == null: return false
	
	if _test_if_derivitive_of_class(test_class.get_base_script(), target_class):
		return true
	
	return false
	
func _install_script_templates() -> void:
	_copy_dir_recursive(TEMPLATE_SOURCE, TEMPLATE_TARGET)
	EditorInterface.get_resource_filesystem().scan()

func _copy_dir_recursive(from_path: String, to_path: String) -> void:
	if not DirAccess.dir_exists_absolute(to_path):
		DirAccess.make_dir_recursive_absolute(to_path)

	var dir := DirAccess.open(from_path)
	if dir == null:
		push_warning("Could not open template source: " + from_path)
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue

		var source := from_path.path_join(file_name)
		var target := to_path.path_join(file_name)

		if dir.current_is_dir():
			_copy_dir_recursive(source, target)
		else:
			if not FileAccess.file_exists(target):
				DirAccess.copy_absolute(source, target)

		file_name = dir.get_next()

	dir.list_dir_end()
