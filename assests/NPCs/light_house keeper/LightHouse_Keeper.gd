extends KinematicBody2D

var velocity = Vector2.ZERO
var is_idle = false
var is_walking = false
var is_interacting = false
var is_playing_lute = false
var speed = 30
var gravity = 15
onready var player = get_node("../../Player")
onready var timer = get_node("timers/state")

func _ready() -> void:
	is_idle = true

func _physics_process(delta: float) -> void:
	if is_idle == true:
		_idle()
	elif is_walking == true:
		_walk()
	elif is_interacting == true:
		_interaction()
	elif is_playing_lute == true:
		_lute_play()
	
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_wall():
		_turn()
	if $area2Ds/Interaction.overlaps_body(player):
		if Input.is_action_just_pressed("interaction"):
				is_interacting = true
				is_idle = false
				is_walking = false
				player._interaction(false)
				var dialogue_box = get_node_or_null("dialogue_box")
				dialogue_box.play_dialogue()
				dialogue_box.active = true
				

func _idle():
	$states.text = "Idle"
	$AnimationPlayer.play("idle")
	is_idle = true
	is_walking = false
	is_playing_lute = false
	velocity.x = 0
	if timer.is_stopped():
		timer.set_wait_time(3)
		timer.start()

func _walk():
	$states.text = "Walking"
	$AnimationPlayer.play("walk")
	is_idle = false
	is_walking = true
	is_playing_lute = false
	velocity.x = speed 
	if timer.is_stopped():
		timer.set_wait_time(6)
		timer.start()
#-----------------lute aimation--------------------------------------
func _lute_idle():
	$states.text = "Idle"
	is_idle = false
	is_walking = false
	is_playing_lute = false
	velocity.x = 0
	$AnimationPlayer.play("lute_idle")

func _sitting():
	$states.text = "Sitting"
	is_idle = false
	is_walking = false
	is_playing_lute = false
	velocity.x = 0
	$AnimationPlayer.play("sitting")

func _lute_play():
	$states.text = "Playing Lute"
	is_playing_lute = true
	is_idle = false
	is_walking = false
	$AnimationPlayer.play("lute_play")
#-----------------------------------------------------------------------------
func _interaction():
	$states.text = "Interaction"
	velocity.x = 0
	$AnimationPlayer.play("idle")
	set_physics_process(false)

func _interaction_finished():
	set_physics_process(true)
	is_interacting = false
	is_idle = true
	is_walking = false
	player._interaction(true)

func _turn():
	$Frames.flip_h = !$Frames.flip_h
	$main_collision.position.x *= -1
	speed *= -1

func _on_state_timeout() -> void:
	if is_idle == true:
		is_idle = false
		is_walking = true
		timer.stop()
	elif is_walking == true:
		is_walking = false
		is_idle = true
		timer.stop()


func _on_Interaction_body_entered(body: Node) -> void:
	if body.name == "Player":
		player = body
		$interaction.text = "(E)interact"
		$interaction.visible = true



func _on_Interaction_body_exited(body: Node) -> void:
	if body.name == "Player":
		$interaction.text = "(E)interact"
		$interaction.visible = false


func _on_sit_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("sit_area"):
		
		if $Frames.flip_h == false:
			print("time to sit")
			_lute_idle()
