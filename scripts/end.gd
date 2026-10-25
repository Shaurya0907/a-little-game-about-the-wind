extends Control
@onready var label: Label = $Label
@onready var cover: Sprite2D = $cover
@onready var no: Button = $no
@onready var yes_2: Button = $yes2
@onready var yes: Button = $yes


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false
	cover.visible = false
	yes_2.visible = false


func _on_yes_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/outro.tscn")


func _on_no_pressed() -> void:
	cover.visible = true
	label.visible = true
	no.visible = false
	yes_2.visible = true
	yes.visible = false

func _on_yes_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
