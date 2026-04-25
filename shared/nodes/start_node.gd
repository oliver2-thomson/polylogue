@tool

extends PolylogueNodeBase
class_name StartNode

func _init() -> void:
	input_slots = [-1]

# Override so that the start node cannot be deleted
func add_custom_controls() -> Control:
	return null
