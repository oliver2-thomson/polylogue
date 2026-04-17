@tool

extends SingleNextNode
class_name LineNode

@export var character: Character
@export var line: String

func add_custom_controls() -> Control:
	var panel = PanelContainer.new()
	var text_area = LineEdit.new()
	text_area.custom_minimum_size = Vector2(500, 100)
	text_area.text = line
	text_area.text_changed.connect(change_line)

	panel.add_child(text_area)
	
	return panel
	
	
func change_line(_line: String):
	line = _line

# Might be nice to resize based on a mouse hover
func set_custom_minimum_size(text_area: TextEdit, size: Vector2):
	text_area.custom_minimum_size = size
