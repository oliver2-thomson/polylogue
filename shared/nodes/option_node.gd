@tool

extends PolylogueNodeBase
class_name OptionNode

@export var character: Character
@export var line: String
@export var options: Array[BranchOption]

func advance(input: Variant = null) -> int:
	if typeof(input) != TYPE_INT:
		printerr("OptionNode expected int input")
		return -1
		
	var index := input as int
	if index < 0 or index >= options.size():
		printerr("Option index out of bounds")
		return -1
		
	return options[index].next_id

func get_output_slots() -> int:
	return len(options)
