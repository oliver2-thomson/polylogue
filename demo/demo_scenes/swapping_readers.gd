extends Control


@onready var character_title_label: Label = $VBoxContainer/CharacterTitleLabel
@onready var dialogue_label: Label = $VBoxContainer/DialogueLabel
@onready var options_box: VBoxContainer = $VBoxContainer/OptionsBox
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var advance_button: Button = $VBoxContainer/AdvanceButton

@export var current_reader: Reader

@onready var conversation_1_reader: Reader = $HBoxContainer/Conversation1Button/Conversation1Reader
@onready var conversation_2_reader: Reader = $HBoxContainer/Conversation2Button/Conversation2Reader
@onready var conversation_3_reader: Reader = $HBoxContainer/Conversation3Button/Conversation3Reader


func _ready() -> void:
	if current_reader:
		connect_to_reader(current_reader)

func _on_conversation_1_button_pressed() -> void:
	disconnect_current_reader()
	connect_to_reader(conversation_1_reader)


func _on_conversation_2_button_pressed() -> void:
	disconnect_current_reader()
	connect_to_reader(conversation_2_reader)


func _on_conversation_3_button_pressed() -> void:
	disconnect_current_reader()
	connect_to_reader(conversation_3_reader)

func connect_to_reader(reader: Reader):
	reader.started.connect(_on_started)
	reader.exited.connect(_on_exited)
	reader.node_ready.connect(_on_node_ready)
	reader.polylogue_signal_emitted.connect(_on_polylogue_signal_emitted)
	reader.branch_requested.connect(_on_branch_requested)
	current_reader = reader

func disconnect_current_reader():
	current_reader.exit("Disconnected reader from UI")
	current_reader.disconnect("started", _on_started)
	current_reader.disconnect("exited", _on_exited)
	current_reader.disconnect("node_ready", _on_node_ready)
	current_reader.disconnect("polylogue_signal_emitted", _on_polylogue_signal_emitted)
	current_reader.disconnect("branch_requested", _on_branch_requested)

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
					new_button.pressed.connect(current_reader.advance.bind(option_index))

func _on_polylogue_signal_emitted(event_name: String, payload: Variant) -> void:
	print("Signal: {0} emitted with payload: {1}".format([event_name, payload]))

func _on_branch_requested(condition: String, payload: Variant) -> void:
	current_reader.advance(false)


func _on_advance_button_pressed() -> void:
	current_reader.advance()


func _on_start_button_pressed() -> void:
	current_reader.start()
