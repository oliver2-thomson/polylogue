@tool

extends PolylogueNodeBase
class_name SignalNode

@export var string_identifier: String = ""
@export var payload: Variant

func auto_advance() -> bool:
	return true
	
func open_inspector_on_select():
	return true
