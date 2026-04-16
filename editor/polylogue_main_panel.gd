@tool

extends GraphEdit
class_name PolylogueMainPanel

var conversation: Conversation

@onready var label: Label = $PanelContainer/Label

func set_conversation(_conversation):
	conversation = _conversation
	label.text = conversation.title
	redraw()
	
func redraw():
	pass
