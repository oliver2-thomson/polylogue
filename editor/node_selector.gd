@tool

extends MenuButton
class_name NodeSelector

signal node_chosen(node_key: String, state: Dictionary)

var options: Dictionary = {}
var state: Dictionary = {}

func _ready() -> void:
	get_popup().id_pressed.connect(_popup_id_pressed)

func _on_about_to_popup() -> void:
	get_popup().clear()
	
	_refresh_options()
	for option in len(options.keys()):
		get_popup().add_item(options.keys()[option], option)

func _refresh_options():
	options = PolylogueInterface.instantiable_node_types

func _popup_id_pressed(id: int):
	hide()
	node_chosen.emit(options.keys()[id], state)
	
func store_state(dict: Dictionary):
	state = dict
	
func get_state():
	return state
	
func choose_node_to_spawn(_state: Dictionary):
	show()
	show_popup()
	grab_focus()
	state = _state


func _on_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		hide()
