extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 10
var is_idle = false
var is_flying = false
var is_eating = false
export var startpos = false

func _ready() -> void:
	is_idle = true
	if startpos == true:
		_turn()

func _physics_process(delta: float) -> void:
	if is_idle == true:
		_idle()
	elif is_flying == true:
		_flying()
	elif is_eating == true:
		_eating()
	
	velocity = move_and_slide(velocity , Vector2.UP)
	velocity.y += 15
	if !$Ground_check.is_colliding() and is_flying == false:
		_turn()
	if is_on_wall():
		_turn()

func _turn():
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	$Ground_check.position.x = -$Ground_check.position.x
	speed *= -1

func _idle():
	$AnimationPlayer.play("idle")
	velocity.x = speed
	if $Idle_t.is_stopped():
		$Idle_t.wait_time = 1
		$Idle_t.start()

func _eating():
	velocity.x = 0
	$AnimationPlayer.play("eating")
	if $Idle_t.is_stopped():
		$Idle_t.wait_time =  4
		$Idle_t.start()

func _flying():
	if $AnimatedSprite.flip_h == true:
		velocity = Vector2(-50,-50)
	elif $AnimatedSprite.flip_h == false:
		velocity = Vector2(50,-50)
	
	$Idle_t.stop()
	$AnimationPlayer.play("fly")


func _on_Idle_t_timeout() -> void:
	if is_idle == true:
		is_idle = false
		is_eating = true
	elif is_eating == true:
		is_idle = true
		is_eating = false
		_turn()


func _on_Area2D_body_entered(body: Node) -> void:
	is_idle = false
	is_eating = false
	is_flying = true
	#if anything except ground enters --> fly
	#fix chippy animation
