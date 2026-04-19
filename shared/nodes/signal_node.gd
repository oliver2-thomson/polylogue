@tool

extends SingleNextNode
class_name SignalNode

@export var signal_name: String = ""
@export var payload: Variant

func auto_advance() -> bool:
	return true

func add_custom_controls() -> Control:
	var vbox = VBoxContainer.new()
	var signal_name_edit = LineEdit.new()
	
	signal_name_edit.text = signal_name
	signal_name_edit.text_changed.connect(change_signal_name)
	
	vbox.add_child(signal_name_edit)
	
	return vbox

func change_signal_name(_signal_name: String):
	signal_name = _signal_name
