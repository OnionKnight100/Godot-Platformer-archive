extends Node2D


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		$AnimationPlayer.play("animation")

func _on_Area2D_body_exited(body: Node) -> void:
	if body.name == "Player":
		$AnimationPlayer.play_backwards("animation")
