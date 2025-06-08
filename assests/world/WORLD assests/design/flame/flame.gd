extends Node2D

export var x_size = 1
export var y_size = 1

func _ready() -> void:
	$Light2D.scale.x = x_size
	$Light2D.scale.y = y_size

func _process(delta: float) -> void:
	$AnimationPlayer.play("flame")
