extends Area2D

var is_in_open_area = false
var chest_opened = false

func _ready() -> void:
	$Label.visible = false
	$chest_open.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interaction"):
		if is_in_open_area == true:
			$chest_open.visible = true
			$chest_closed.visible = false
			chest_opened = true


func _on_chest_wall_body_entered(body: Node) -> void:
	if body.name == "Player":
		is_in_open_area = true
		if chest_opened == false:
			$Label.text = "(E) Open"
		elif chest_opened == true:
			$Label.text = "(E) Check again"
		$Label.visible = true
		




func _on_chest_wall_body_exited(body: Node) -> void:
	$Label.visible = false
	is_in_open_area = false
