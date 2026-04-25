@tool

extends PolylogueNodeBase
class_name SignalNode

@export var signal_name: String = ""
@export var payload: Variant

func auto_advance() -> bool:
	return true
	
func open_inspector_on_select():
	return true
