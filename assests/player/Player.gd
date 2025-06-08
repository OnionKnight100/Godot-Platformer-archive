extends KinematicBody2D

onready var Arrow = preload("res://assests/player/Bows/arrow/Arrow_Player.tscn")
var velocity = Vector2.ZERO
export var Sword_position = Vector2.ZERO
export var Sword_rotation :float = 0
export var Bow_position = Vector2.ZERO
export var Bow_rotation :float = 0
var speed = 90
var jump_force = -300
var gravity = 14
#--------------health and all--------------------------------
var health = 100
var max_health = 100
#-----------------------------------------------------------
onready var step = "res://assests/sounds/soundeffects/walk/step1.wav"
onready var jump_hit = "res://assests/sounds/soundeffects/ground_hit/ground_hit.wav"
#----------------triggers-----------------------
var is_idle = false
var is_running = false
var anim_finished = true
var is_dead = false
var looking_left = false
var is_negative = false
var small_fall = false
var on_air = false
var knockback = false
var bow_selected = false
var sword_selected = false
var spell_selected = false
var slot_num = 0
var shield_on = false
#---------------------------------------------------
func _ready() -> void:
	_load_values()
	

func _physics_process(delta) -> void:
	_give_hud_values()
	#---------------animation signals-----------------------------------------------
	var shrine = get_tree().get_root().find_node("SaveShrine" , true , false)
	if not shrine.is_connected("animation_on" , self , "_pray"):
		shrine.connect("animation_on", self , "_pray")
	#-------------------------------------------------------------------------------
	if health <= 0:
		#print("dead")
		pass
	
	# moving mechanics.................................................
	if knockback == false:
		if Input.is_action_pressed("go_left"):
			looking_left = true
			_move(-1)
			$AnimatedSprite.flip_h = true
			$Swords.flip_h = true
			$Bows.flip_h = true
		
		elif Input.is_action_pressed("go_right"):
			looking_left = false
			_move(1)
			$AnimatedSprite.flip_h = false
			$Swords.flip_h = false
			$Bows.flip_h = false
		else:
			_idle()
		
		if Input.is_action_just_pressed("Sword"):
			slot_num = 1
			$Bows.visible = false
			$Swords.visible = true
			sword_selected = true
			bow_selected = false
			spell_selected = false
		elif Input.is_action_just_pressed("Bow"):
			slot_num = 2
			$Bows.visible = true
			$Swords.visible = false
			sword_selected = false
			bow_selected = true
			spell_selected = false
		elif Input.is_action_just_pressed("Spell"):
			slot_num = 3
			$Bows.visible = false
			$Swords.visible = false
			sword_selected = false
			bow_selected = false
			spell_selected = true
	#----------------turn mechanics--------------------------------------------------------------------------------
	if looking_left == true:
		if is_negative == false:
			$trigger_areas/attack_detect/CollisionShape2D.position.x = -$trigger_areas/attack_detect/CollisionShape2D.position.x
			is_negative = true
	elif looking_left == false:
		if is_negative == true:
			$trigger_areas/attack_detect/CollisionShape2D.position.x *= -1
			is_negative = false
	else:
		pass
	
	if looking_left == true:
		$Swords.position.x = -Sword_position.x
		$Swords.position.y = Sword_position.y
		$Swords.rotation_degrees = -Sword_rotation
		#-----Bow-----------------------------------------
		$Bows.position.x = -Bow_position.x
		$Bows.position.y = Bow_position.y
		$Bows.rotation_degrees = -Bow_rotation
	else:
		$Swords.position.x = Sword_position.x
		$Swords.position.y = Sword_position.y
		$Swords.rotation_degrees = Sword_rotation
		#-----Bow-----------------------------------------
		$Bows.position.x = Bow_position.x
		$Bows.position.y = Bow_position.y
		$Bows.rotation_degrees = Bow_rotation
	#---------------air mechanics---------------------------------------
	if knockback == false:
		if !is_on_floor():
			$Action.text = "On Air"
			if velocity.y > 40 :
				$Action.text = "falling"
				if anim_finished == true:
					$AnimationPlayer.play("small_fall")
			else:
				if anim_finished == true:
					$AnimationPlayer.play("jump")
	if !is_on_floor():
		on_air = true
	if is_on_floor() and on_air == true:
		$audio/jump_hit.play()
		on_air = !is_on_floor()
	
	# gravity-------------------------------------------------------------
	velocity.y += gravity
	#----------------------------------------------------------------------
	if knockback == false:
		if Input.is_action_just_pressed("jump"):
			if is_on_floor() and anim_finished == true:
				_jump()
	#--------------------------attack mechanics-----------------------------------
		elif Input.is_action_just_pressed("attack"):
			if is_on_floor():
				if sword_selected == true:
					_sword_attack()
				elif bow_selected == true:
					_bow_attack()
				elif spell_selected == true:
					pass
	#---------------------------------------------------------------------
	velocity = move_and_slide(velocity,Vector2.UP,true)




func _move(dir):
	if anim_finished == true:
		is_idle = false
		is_running = true
		velocity.x =  dir * speed
		$Action.text = "Moving"
		if is_running == true:
			if anim_finished == true:
				$AnimationPlayer.play("run")
		if $timers/Timer.time_left <= 0 and is_on_floor():
			$audio/step.pitch_scale = rand_range(0.8,1.2)
			$audio/step.play()
			$timers/Timer.start(0.4)

func _interaction(d):
	set_physics_process(d)
	$AnimationPlayer.play("idle")
#----extra animations----------------------------------------------------
func _pray():
	print("praying")
	#put praying animation and set player process to false
#-------------------------------------------------------------------------
func _idle():
	is_idle = true
	is_running = false
	velocity.x = 0
	$Action.text = "Idle"
	if is_idle == true:
		if anim_finished == true:
			$AnimationPlayer.play("idle")

func _knock_back(direction , damage_t):
	health -= damage_t
	var dir = direction * 400
	knockback = true
	velocity.x = lerp(velocity.x , dir , 0.2)
	velocity.y = lerp(velocity.y , -150 , 0.2)
	$AnimationPlayer.play("knockback")

func _knockback_remove():
	knockback = false

func _jump():
	velocity.y = jump_force
	$Action.text = "jump"


func _sword_attack():
	anim_finished = false
	velocity.x = 0
	$AnimationPlayer.play("attack_sword")
	if looking_left == true:
		position.x -= 8
	elif looking_left == false:
		position.x += 8

func _bow_attack():
	anim_finished = false
	velocity.x = 0
	$AnimationPlayer.play("attack_bow")
func _arrow_launch():
	var arrow = Arrow.instance()
	if looking_left == true:
		arrow.dir = -1
		arrow._attack_dir_here(true)
	elif looking_left == false:
		arrow.dir = 1
		arrow._attack_dir_here(false)
	arrow.global_position = $Positions/arrow_position.global_position
	get_tree().current_scene.add_child(arrow)

func _give_hud_values():
	Hud._take_values(max_health , health , slot_num)

func _load_values():
	position.x = SaveScript.data["player"]["position"]["pos_x"]
	position.y = SaveScript.data["player"]["position"]["pos_y"]
	health = SaveScript.data["player"]["attributes"]["health"]
	max_health = SaveScript.data["player"]["attributes"]["max_hp"]


func _save():
	SaveScript.data["player"]["position"]["pos_x"] = position.x 
	SaveScript.data["player"]["position"]["pos_y"] = position.y
	SaveScript.data["player"]["attributes"]["max_hp"] = max_health
	SaveScript.data["player"]["attributes"]["health"] = health



#-----------------animation-------------------------------------------
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	anim_finished = true
#------------------triggers-------------------------------------------

func _on_attack_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		var enemy = area.get_parent().get_parent()
		enemy.health -= 20
		if looking_left == true:
			enemy._knock_back(true)
		else:
			enemy._knock_back(false)
