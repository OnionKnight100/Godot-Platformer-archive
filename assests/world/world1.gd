extends Node2D


func _process(delta: float) -> void:
	pass


func _on_Level_restart_body_entered(body: Node) -> void:
	if body.name == "Player":
		get_tree().change_scene("res://assests/world/world1.tscn")
	elif body.name == "enemy":
		body.queue_free()
