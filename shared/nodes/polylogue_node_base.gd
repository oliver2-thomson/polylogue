@tool

extends Resource
class_name PolylogueNodeBase

var uid: int
var position: Vector2 = Vector2(0, 0)

func set_uid(id: int):
	uid = id
	
func get_uid() -> int:
	return uid
	
func advance(input: Variant = null) -> int:
	push_error("respond() not implemented for %s" % get_class())
	return -1

func auto_advance() -> bool:
	return false

func get_input_slots() -> int:
	return 1

func get_output_slots() -> int:
	return 1
	
func get_output_destinations() -> Array[int]:
	return []
	
func set_position(_posiiton: Vector2):
	position = _posiiton
