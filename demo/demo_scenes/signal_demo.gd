extends Reader


@onready var character_title_label: Label = $VBoxContainer/CharacterTitleLabel
@onready var dialogue_label: Label = $VBoxContainer/DialogueLabel
@onready var options_box: VBoxContainer = $VBoxContainer/OptionsBox
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var advance_button: Button = $VBoxContainer/AdvanceButton

@onready var lightbulb_texture_rect: TextureRect = $HBoxContainer/VBoxContainer/LightbulbTextureRect
@onready var money_label: Label = $HBoxContainer/VBoxContainer2/MoneyLabel
@onready var dog_name_label: Label = $HBoxContainer/VBoxContainer3/DogNameLabel

var money: int = 100

var lightbulb_on_tecture := preload("res://addons/polylogue/demo/demo_assets/lightbulb_on.png")
var lightbulb_off_texture := preload("res://addons/polylogue/demo/demo_assets/lightbulb_off.png")

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
	options_box.hide()
	for child in options_box.get_children():
		child.queue_free()
	
	# Present Node
	if node is SpeechNode:
		character_title_label.text = node.character.name
		if node is LineNode:
			dialogue_label.text = node.get_line()
			if node is OptionNode:
				advance_button.hide()
				options_box.show()
				var options = node.get_options()
				for option_index in range(len(options)):
					var option = options[option_index]
					var new_button = Button.new()
					new_button.text = option
					new_button.pressed.connect(advance.bind(option_index))
					options_box.add_child(new_button)

func _on_polylogue_signal_emitted(event_name: String, payload: Variant) -> void:
	if event_name == "SET_LIGHTBULB_STATE" and payload is bool:
		if payload:
			lightbulb_texture_rect.texture = lightbulb_on_tecture
		else:
			lightbulb_texture_rect.texture = lightbulb_off_texture
	
	elif event_name == "ADD_MONEY" and payload is int:
		money += payload
		money_label.text = "You have {0} Money".format([money])
	
	elif event_name == "NAME_DOG" and payload is String:
		dog_name_label.text = "The dog is called: " + payload

func _on_branch_requested(condition: String, payload: Variant) -> void:
	advance(false)
