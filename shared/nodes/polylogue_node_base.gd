extends Resource
class_name PolylogueNodeBase

@export var uid: int

func set_uid(id: int):
	uid = id
	
func advance(input: Variant = null) -> int:
	push_error("respond() not implemented for %s" % get_class())
	return -1

func auto_advance() -> bool:
	return false
