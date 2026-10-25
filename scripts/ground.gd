extends StaticBody2D
@onready var area_2d: Area2D = $Area2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		get_tree().change_scene_to_file("res://scenes/end.tscn")
