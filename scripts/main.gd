extends Node2D

@onready var fade: ColorRect = $fade
@onready var fade_anim: AnimationPlayer = $fade/AnimationPlayer

func _ready():
	fade_anim.play("fade_in")
	await fade_anim.animation_finished
	fade.hide()
