extends CharacterBody2D

@onready var player: AnimatedSprite2D = $player_animated
@onready var anim_player: AnimationPlayer = $player_animated/AnimationPlayer

var player_health = 100
const SPEED = 70
var isjump = false

func _physics_process(delta: float) -> void:
	
	var direction = Input.get_axis("move_backward", "move_forward")	
	if Input.is_action_pressed("move_forward"):
		velocity.x = direction * SPEED 
		if not anim_player.current_animation == "jump":
			anim_player.play("walking")
	elif Input.is_action_pressed("move_backward"):
		velocity.x = direction * SPEED 
		if not anim_player.current_animation == "jump":
			anim_player.play("walking")
	elif Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_backward"):
		velocity.x = 0
		#if not isjumping:
		anim_player.play("idle")
	velocity.y += 20  #gravity during normal scenario
	
	#Flips the player
	if velocity.x > 0:
		player.flip_h = false
		
	if velocity.x < 0:
		player.flip_h = true
	
	
	if Input.is_action_just_pressed("jump") and not isjump:
		velocity.y = -240
		anim_player.play("jump")
		await anim_player.animation_finished
	
	if not is_on_floor():
		isjump = true
	else:
		isjump = false
		
	move_and_slide()
