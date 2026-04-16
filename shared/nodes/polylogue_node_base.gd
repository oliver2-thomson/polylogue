@tool

extends Resource
class_name PolylogueNodeBase

@export var uid: int
@export var position: Vector2 = Vector2(0, 0)

func set_uid(id: int):
	uid = id
	
func advance(input: Variant = null) -> int:
	push_error("respond() not implemented for %s" % get_class())
	return -1

func auto_advance() -> bool:
	return false

func get_input_slots() -> int:
	return 1

func get_output_slots() -> int:
	return 1
