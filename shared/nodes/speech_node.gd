@tool
@abstract

extends PolylogueNodeBase
class_name SpeechNode

@export var character: Character

func add_custom_controls(controls: VBoxContainer) -> VBoxContainer:
	controls = super.add_custom_controls(controls)
	
	var character_box := HBoxContainer.new()
	var character_label := Label.new()
	if character:
		character_label.text = character.name
	else:
		character_label.text = "Character = Null"
	var character_picker := EditorResourcePicker.new()
	character_picker.base_type = "Character"
	character_picker.resource_changed.connect(_set_character)
	
	character_box.add_child(character_label)
	character_box.add_child(character_picker)
	
	controls.add_child(character_box)
	return controls

func _set_character(_character: Character):
	character = _character
	request_redraw.emit()

func get_character() -> Character:
	return character
