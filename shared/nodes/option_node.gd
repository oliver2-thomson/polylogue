@tool

extends PolylogueNodeBase
class_name OptionNode

@export var character: Character
@export var line: String
@export var options: Array[String] = [""]

func add_custom_controls() -> Control:
	var custom_controls = HBoxContainer.new()
	
	var left_button = Button.new()
	left_button.text = "-"
	left_button.pressed.connect(increment_options.bind(-1))
	
	var right_button = Button.new()
	right_button.text = "+"
	right_button.pressed.connect(increment_options.bind(1))
	
	custom_controls.add_child(left_button)
	custom_controls.add_child(right_button)
	
	return custom_controls

func advance(input: Variant = null) -> int:
	if typeof(input) != TYPE_INT:
		printerr("OptionNode expected int input")
		return -1
		
	var index := input as int
	if index < 0 or index >= options.size():
		printerr("Option index out of bounds")
		return -1
		
	return output_slots[index]

func increment_options(amount: int):
	while amount != 0:
		if amount > 0:
			output_slots.append(0)
			amount -= 1
		elif amount < 0:
			if len(output_slots) < 1:
				output_slots = [0]
				amount = 0
			elif len(output_slots) == 1:
				amount = 0
			elif len(output_slots) > 1:
				output_slots.pop_back()
				amount += 1
				
				
	equalise_options()
	request_redraw.emit()
				
func equalise_options():
	print("Start -> len(options): {0}, len(output_slots): {1}".format([len(options), len(output_slots)]))
	if len(options) > len(output_slots):
		options = options.slice(0, len(output_slots))
	elif len(options) < len(output_slots):
		for i in range(len(output_slots) - len(options)):
			options.append("")
				
				
	print("End -> len(options): {0}, len(output_slots): {1}".format([len(options), len(output_slots)]))
				
				
func add_inline_controls(index: int) -> Control:
	var line_edit = LineEdit.new()
	line_edit.text = options[index]
	line_edit.text_changed.connect(_set_option.bind(index))
	return line_edit
	
func _set_option(value: String, index: int):
	if index < len(options):
		options[index] = value
