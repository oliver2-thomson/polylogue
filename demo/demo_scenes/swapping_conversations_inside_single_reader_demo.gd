extends Reader

@export var character_title_label: Label
@export var dialogue_label: Label
@export var options_box: VBoxContainer
@export var start_button: Button
@export var advance_button: Button

var conversation_1 = preload("res://addons/polylogue/demo/demo_conversations/simple_greeting.tres")
var conversation_2 = preload("res://addons/polylogue/demo/demo_conversations/simple_catchup.tres")
var conversation_3 = preload("res://addons/polylogue/demo/demo_conversations/simple_fight.tres")

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	advance_button.pressed.connect(_on_advance_button_pressed)

func _on_start_button_pressed() -> void:
	start()

func _on_advance_button_pressed() -> void:
	advance()
	
func _on_started() -> void:
	character_title_label.show()
	dialogue_label.show()
	advance_button.show()
	start_button.hide()
	options_box.hide()

func _on_exited(reason: String) -> void:
	start_button.show()
	character_title_label.hide()
	dialogue_label.hide()
	advance_button.hide()
	options_box.hide()


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


func _on_polylogue_signal_emitted(event_name: String, payload: Variant) -> void:
	print("Signal: {0} emitted with payload: {1}".format([event_name, payload]))


func _on_branch_requested(condition: String, payload: Variant) -> void:
	advance(false)


func _on_conversation_1_button_pressed() -> void:
	set_conversation(conversation_1)


func _on_conversation_2_button_pressed() -> void:
	set_conversation(conversation_2)


func _on_conversation_3_button_pressed() -> void:
	set_conversation(conversation_3)
