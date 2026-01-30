extends Resource
class_name Conversation

@export_group("Metadata")
@export var title: String
@export var start_node_id: String
@export var node_positions: Dictionary[String, Vector2]

@export_group("")
@export var nodes: Dictionary[String, Resource]
@export var edges: Dictionary
