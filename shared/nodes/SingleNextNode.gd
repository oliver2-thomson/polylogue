@tool

extends PolylogueNodeBase
class_name SingleNextNode

func advance(input: Variant = null) -> int:
	print(output_slots)
	return output_slots[0]
