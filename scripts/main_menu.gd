extends Node2D
var btn = ""
@onready var fade_anim: AnimationPlayer = $fade/AnimationPlayer
@onready var fade: ColorRect = $fade
@onready var fade_timer: Timer = $fade/fade_timer

func _ready():
	fade_anim.play("fade_in")
	await fade_anim.animation_finished
	fade.hide()
	
func _on_play_pressed() -> void:
	btn = "play"
	fade.show()
	fade_timer.start()
	fade_anim.play("fade_out")

func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	btn = "quit"
	fade.show()
	fade_timer.start()
	fade_anim.play("fade_out")

func _on_fade_timer_timeout() -> void:
	if btn == "play":
		get_tree().change_scene_to_file("res://scenes/intro.tscn")
	elif btn == "quit":
		get_tree().quit()
		
