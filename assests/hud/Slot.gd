extends Sprite

func _ready() -> void:
	pass

func _glow():
	$glow.visible = true
func _dark():
	$glow.visible = false
