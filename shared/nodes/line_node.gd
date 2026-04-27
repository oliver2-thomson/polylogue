@tool

extends SpeechNode
class_name LineNode

@export var line: String

func add_custom_controls() -> VBoxContainer:
	var parent_class_controls := super.add_custom_controls()
	
	var text_area = LineEdit.new()
	text_area.custom_minimum_size = Vector2(500, 100)
	text_area.text = line
	text_area.text_changed.connect(_change_line)

	parent_class_controls.add_child(text_area)
	
	return parent_class_controls
	
	
func _change_line(_line: String):
	line = _line

# Might be nice to resize based on a mouse hover
func set_custom_minimum_size(text_area: TextEdit, size: Vector2):
	text_area.custom_minimum_size = size

func get_line() -> String:
	return line
