@tool

extends PolylogueNodeBase
class_name SingleNextNode

func advance(input: Variant = null) -> int:
	return output_slots[0]
