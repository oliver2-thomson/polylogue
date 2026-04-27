@tool

extends SignalNode
class_name BranchNode

func _init() -> void:
	output_slots = [0, 0]

func add_inline_controls(index: int) -> Control:
	var inline_label: Label = Label.new()
	if index == 0:
		inline_label.text = "True"
	elif index == 1:
		inline_label.text = "False"
	
	return inline_label
	
func advance(input: Variant = null) -> int:
	if !(input is bool) or input == null:
		printerr("BranchNode expected bool input")
		return -1

	var input_bool := input as bool
	if input_bool:
		return output_slots[0]
	else:
		return output_slots[1]

func auto_advance() -> bool:
	return false
