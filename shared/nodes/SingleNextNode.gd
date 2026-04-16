@tool

extends PolylogueNodeBase
class_name SingleNextNode

@export var next_id: int = 0

func set_next_id(id: int):
	next_id = id

func advance(input: Variant = null) -> int:
	return next_id
