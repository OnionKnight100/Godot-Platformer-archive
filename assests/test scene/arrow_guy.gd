extends KinematicBody2D

var ARROW = preload("res://assests/test scene/arrow.tscn")
var player = null
var health = 100

var is_idle = false
var is_attacking = false
var is_reloading = false
var knockback = false
var anim_finished = true
var velocity = Vector2.ZERO

func _ready() -> void:
	is_idle = true

func _physics_process(delta: float) -> void:
	print(health)
	if is_idle == true:
		_idle()
	elif is_attacking == true:
		_attacking()
	elif knockback == true:
		knockback
	
	velocity = move_and_slide(velocity)
	velocity.y += 10

func _fire():
	var arrow = ARROW.instance()
	arrow.player = player
	arrow.position = $hand.position
	add_child(arrow)
	
func _idle():
	print("idle")
	$AnimationPlayer.play("idle")
	knockback = false
	velocity.x = 0

#func turn():
##	$triggers/player_detect/CollisionPolygon2D.position.x *= -1
##	$triggers/attack_detect/CollisionShape2D.position.x *= -1
##	$triggers/back_detect/CollisionShape2D.position.x *= -1
##	$hand.flip_h = !$hand.flip_h
##	$main_body.flip_h = !$main_body.flip_h
##	$top_hand.flip_h = !$top_hand.flip_h
##	scale.x *= -1
#	pass

func _knock_back():
	print("knockback")
	knockback = true
	is_idle = false
	is_attacking = false
	$AnimationPlayer.play("knockback")
	velocity.x = lerp(velocity.x,200,0.5)
	velocity = move_and_slide(velocity)

func _attacking():
	print("attacking")
	$hand.look_at(player.global_position)
	$top_hand.look_at(player.global_position)
	if $timers/attack_delay.is_stopped():
		$AnimationPlayer.play("attack")
		$timers/attack_delay.set_wait_time(1)
		$timers/attack_delay.start()
	

func _on_player_detect_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		if knockback == false:
			player = body
			is_attacking = true
			is_idle = false
			


func _on_player_detect_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		if knockback == false:
			is_attacking = false
			is_idle = true
			$timers/attack_delay.stop()



func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	anim_finished = true
