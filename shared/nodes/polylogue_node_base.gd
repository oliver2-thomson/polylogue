@tool

extends Resource
class_name PolylogueNodeBase

signal request_redraw()

@export var uid: int
var position: Vector2 = Vector2(0, 0)

@export var input_slots: Array[int] = [0]
@export var output_slots: Array[int] = [0]

func set_uid(id: int):
	uid = id
	
func get_uid() -> int:
	return uid
	
func advance(input: Variant = null) -> int:
	push_error("respond() not implemented for %s" % get_class())
	return -1

func auto_advance() -> bool:
	return false

func get_input_slots() -> Array[int]:
	return input_slots

func get_output_slots() -> Array[int]:
	return output_slots
	
func set_position(_posiiton: Vector2):
	position = _posiiton

func set_output_slot(index: int, destination: int):
	if index >= len(output_slots): 
		printerr("out of bounds assignment for output slot")
		return
	
	output_slots[index] = destination

func add_custom_controls() -> Control:
	return null
	
func add_inline_controls(index: int) -> Control:
	return null
