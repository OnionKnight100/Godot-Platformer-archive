extends Light2D

var finished = false
var lights_down = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not get_parent().is_connected("animation_on", self , "start_animation"):
		get_parent().connect("animation_on", self , "start_animation")
	if lights_down == true:
		if energy < 5 and finished == false:
			energy += 3 * delta
		elif energy < 0:
			energy = 0
			lights_down = false
		else:
			finished = true
			energy -= 3 * delta

func start_animation():
	lights_down = true
	finished = false
	print("signal connected!")

