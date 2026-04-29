extends Reader


@onready var character_title_label: Label = $VBoxContainer/CharacterTitleLabel
@onready var dialogue_label: Label = $VBoxContainer/DialogueLabel
@onready var options_box: VBoxContainer = $VBoxContainer/OptionsBox
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var advance_button: Button = $VBoxContainer/AdvanceButton


func _on_start_button_pressed() -> void:
	start()
	character_title_label.show()
	dialogue_label.show()
	advance_button.show()
	start_button.hide()


func _on_advance_button_pressed() -> void:
	advance()


func _on_exited(reason: String) -> void:
	start_button.show()
	character_title_label.hide()
	dialogue_label.hide()
	advance_button.hide()


func _on_node_ready(node: PolylogueNodeBase) -> void:
	# Reset the UI
	character_title_label.text = ""
	dialogue_label.text = ""
	advance_button.show()
	for child in options_box.get_children():
		child.queue_free()
	
	# Present Node
	if node is SpeechNode:
		character_title_label.text = node.character.name
		if node is LineNode:
			dialogue_label.text = node.get_line()
			if node is OptionNode:
				advance_button.hide()
				for option_index in len(node.get_options()):
					var option = node.get_options()[option_index]
					var new_button = Button.new()
					new_button.text = option
					new_button.pressed.connect(advance.bind(option_index))
	
	if node is SignalNode:
		_handle_signal(node)
	
	if node is BranchNode:
		_handle_branch(node)

func _handle_signal(signal_node: SignalNode):
	print("Signal: {0} emitted with payload: {1}".format([signal_node.string_identifier, signal_node.payload]))

func _handle_branch(branch_node: BranchNode):
	advance(false)
