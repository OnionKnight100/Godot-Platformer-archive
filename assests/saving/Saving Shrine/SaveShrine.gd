extends Node2D

var label_Visiblity = false
var SaveEligible = false #sees if the player is in area
var nodes = null
signal animation_on

func _ready() -> void:
	label_Visiblity = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interaction"):
		if SaveEligible == true:
			emit_signal("animation_on")
			nodes = get_tree().get_nodes_in_group("Can_Save")
			for i in nodes:
				i._save()
			SaveScript.save_data()
			Hud._Save_Label_anim()

func _process(delta: float) -> void:
	if label_Visiblity == false:
		$Label.visible = false
		SaveEligible = false
	else:
		$Label.visible = true
		SaveEligible = true
	#---------------------------------------------------------
	#---------------------------------------------------------

func _on_Player_Detection_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		label_Visiblity = true

func _on_Player_Detection_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		label_Visiblity = false
