extends Control

@onready var reader: Reader = $Reader
@onready var dialogue_playing_container: VBoxContainer = $VBoxContainer/DialoguePlayingContainer
@onready var play_dialogue_button: Button = $VBoxContainer/PlayDialogueButton
@onready var character_name_label: Label = $VBoxContainer/DialoguePlayingContainer/HBoxContainer/CharacterNameLabel
@onready var dialogue_line_label: Label = $VBoxContainer/DialoguePlayingContainer/HBoxContainer/DialogueLineLabel
@onready var options_container: VBoxContainer = $VBoxContainer/DialoguePlayingContainer/HBoxContainer/OptionsContainer
@onready var advance_dialogue_button: Button = $VBoxContainer/DialoguePlayingContainer/AdvanceDialogueButton


func _on_play_dialogue_button_pressed() -> void:
	reader.start()
	play_dialogue_button.hide()
	dialogue_playing_container.show()


func _on_reader_exited(reason: String) -> void:
	dialogue_playing_container.hide()
	play_dialogue_button.show()


func _on_advance_dialogue_button_pressed() -> void:
	reader.advance()


func _on_reader_polylogue_signal_emitted(event_name: String, payload: Variant) -> void:
	print("event: {0} triggered with payload: {1}".format([event_name, payload]))


func _on_reader_node_ready(node: PolylogueNodeBase) -> void:
	reset_ui()
	
	if node is SpeechNode:
		var character: Character = node.character
		character_name_label.text = character.name
	
	if node is LineNode:
		dialogue_line_label.text = node.get_line()
	
	if node is OptionNode:
		advance_dialogue_button.hide()
		var options = node.get_options()
		for option_index in range(len(options)):
			var option_button = Button.new()
			option_button.text = options[option_index]
			option_button.pressed.connect(reader.advance.bind(option_index))
			options_container.add_child(option_button)

func reset_ui():
	character_name_label.text = ""
	dialogue_line_label.text = ""
	advance_dialogue_button.show()
	for child in options_container.get_children():
		child.queue_free()
