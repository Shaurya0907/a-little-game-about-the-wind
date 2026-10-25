extends Node2D

@onready var delay: Timer = $delay
@onready var label_1: Label = $Label1
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3
@onready var label_4: Label = $Label4
@onready var label_5: Label = $Label5
@onready var label_6: Label = $Label6

func _ready():
	label_1.visible = true
	label_2.visible = false
	label_3.visible = false
	label_4.visible = false
	label_5.visible = false
	label_6.visible = false
	delay.start()
	
func _on_delay_timeout() -> void:
	if label_1.visible:
		label_1.visible = false
		label_2.visible = true
		delay.start()	
	elif label_2.visible:
		label_2.visible = false
		label_3.visible = true
		delay.start()	
	elif label_3.visible:
		label_3.visible = false
		label_4.visible = true
		delay.start()	
	elif label_4.visible:
		label_4.visible = false
		label_5.visible = true
		delay.start()	
	elif label_5.visible:
		label_5.visible = false
		label_6.visible = true
		delay.start()
	elif label_6.visible:
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		
		
		
		
