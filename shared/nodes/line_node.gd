@tool

extends SpeechNode
class_name LineNode

@export var line: String

func add_custom_controls() -> Control:
	var parent_class_controls: Control = super.add_custom_controls()
	var controls := VBoxContainer.new()
	
	if parent_class_controls:
		controls.add_child(parent_class_controls)
	
	var text_area = LineEdit.new()
	text_area.custom_minimum_size = Vector2(500, 100)
	text_area.text = line
	text_area.text_changed.connect(change_line)

	controls.add_child(text_area)
	
	return controls
	
	
func change_line(_line: String):
	line = _line

# Might be nice to resize based on a mouse hover
func set_custom_minimum_size(text_area: TextEdit, size: Vector2):
	text_area.custom_minimum_size = size
