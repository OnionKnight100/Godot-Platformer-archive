extends KinematicBody2D

var speed = 80
export var charge_speed = 30
export var walk_speed = 20
var velocity = Vector2.ZERO
var gravity = 24
var jump_force = -300
#----------------triggers--------------------------------
var is_walking = true
var is_idle = false
var is_charging = false
var is_attacking = false
var is_jumping = false
var is_teasing = false
var player_chase = false
var anim_finished = true 
var knock_back = false
var looking_right = false
#-----------------------------------------------------------
#----------health and all -----------------------
var health = 70
var max_health = 70
#-------------------------------------------------
var player1 = null


func _ready() -> void:
	looking_right = true

func _physics_process(delta: float) -> void:
	$health_bar.value = health
	$health_bar.max_value = max_health
	if health <= 0:
		queue_free()
	
	if anim_finished == true:
		if is_idle == true:
			_idle()
		elif is_walking == true:
			_walk()
		elif is_charging == true:
			_charge(delta)
		elif is_attacking == true:
			_attack()
		elif knock_back == true:
			pass
		else:
			print("an error occured")
		
	velocity = move_and_slide(velocity,Vector2.UP)
	
	velocity.y += gravity
	if anim_finished == true:
		if !$ground_detector.is_colliding() and is_charging == false and is_on_floor() or is_on_wall() and is_charging == false:
			_turn()
	if $Jump_detect.is_colliding() and is_charging == true:
		var object = $Jump_detect.get_collider()
		if object.is_in_group("Enemy"):
			_idle()
		if object.is_in_group("Ground"):
			_jump()
	
	if !is_on_floor():
		$A_label.text = "Jumping"
	if velocity.y > 100:
		$A_label.text = "Falling"

func _walk():
	if knock_back == false:
		speed = walk_speed
		$A_label.text = "walking"
		#print("turned to walk")
		$AnimationPlayer.play("walk")
		velocity.x = speed
		if $walk_timer.is_stopped():
			$walk_timer.set_wait_time(5)
			$walk_timer.start()

func _idle():
	if knock_back == false:
		$A_label.text = "idle"
		#print("turned to idle")
		$AnimationPlayer.play("idle")
		velocity.x = 0
		if $idle_timer.is_stopped():
			$idle_timer.set_wait_time(3)
			$idle_timer.start()
	
func _jump():
	if knock_back == false:
		is_jumping = true
		$A_label.text = "jumping"
		if is_on_floor():
		 velocity.y = jump_force


func _charge(del):
	if knock_back == false:
		speed = charge_speed
		#print("turned to charging")
		$A_label.text = "charging"
		var distance = (player1.position.x + 5 - position.x)
		velocity.x = speed + distance * del * 30
		$AnimationPlayer.play("charge")
		

func _attack():
	if knock_back == false:
		if is_on_floor():
			anim_finished = false
			$A_label.text = "Attacking"
			#print("attacking now")
			velocity.x = 0
			$AnimationPlayer.play("Attack")

func _knock_back(is_left: bool):
	anim_finished = false
	$AnimationPlayer.play("knockback")
	if is_left == true:
		velocity.x = lerp(velocity.x , -400 , 0.2)
		velocity.y = lerp(velocity.y , -900 , 0.2)
	elif is_left == false:
		velocity.x = lerp(velocity.x , 400 , 0.2)
		velocity.y = lerp(velocity.y , -900 , 0.2)

func _turn():
	looking_right = !looking_right
	if knock_back == false:
		$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
		$ground_detector.position.x *= -1
		charge_speed *= -1
		walk_speed *= -1
		speed = speed * -1
		$player_detections/player_detect/CollisionShape2D.position.x *= -1
		$player_detections/player_back_detect/CollisionShape2D.position.x *= -1
		$player_detections/attack_detect/CollisionShape2D.position.x *= -1
		$player_detections/slash_attack/CollisionShape2D.position.x *= -1
		$Jump_detect.rotation_degrees *= -1

#----------------timer nodes----------------------------------------------------------
func _on_walk_timer_timeout() -> void:
	if is_charging == true or is_attacking == true:
			is_idle = false
			is_walking = false
	else:
		is_walking = false
		is_idle = true

func _on_idle_timer_timeout() -> void:
	if is_charging == true or is_attacking == true:
			is_idle = false
			is_walking = false
	else:
		is_idle = false
		is_walking = true
#------------------------------------------------------------------------------------

#-------------------Area 2d----------------------------------------------------------
func _on_player_detect_body_entered(body: Node) -> void:
	if body.name == "Player":
		player1 = body
		is_charging = true
		is_idle = false
		is_walking = false
		player_chase = true

func _on_player_back_detect_body_entered(body: Node) -> void:
	if body.name == "Player":
		player1 = body
		_turn()
		is_charging = true
		is_idle = false
		is_walking = false
		player_chase = true

func _on_attack_detect_body_entered(body: Node) -> void:
	if body.name == "Player":
		is_attacking = true
		is_charging = false
		is_idle = false
		is_walking = false

func _on_attack_detect_body_exited(body: Node) -> void:
	if body.name == "Player":
		is_attacking = false
		is_charging = true
		is_idle = false
		is_walking = false


func _on_chase_exit_body_exited(body: Node) -> void:
	if body.name == "Player" and player_chase == true:
		is_charging = false
		is_idle = true
		is_walking = false
		player_chase = false

#--------------Animation Player------------------------------------------------

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	anim_finished = true

#--------------Attack ------------------------------------------------------
func _on_slash_attack_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		#body.health -= 20
		if looking_right == true:
			body._knock_back(1,20)
		elif looking_right == false:
			body._knock_back(-1,20)
