extends Node2D

func _process(delta: float) -> void:
	$blades.rotation_degrees += 10 * delta
