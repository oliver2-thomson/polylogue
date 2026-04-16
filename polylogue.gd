@tool
extends EditorPlugin


const MainPanel = preload("res://addons/polylogue/editor/polylogue_main_panel.tscn")

var main_panel_instance: PolylogueMainPanel

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


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
