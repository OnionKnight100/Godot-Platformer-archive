extends CanvasLayer


func _ready() -> void:
	$half_black.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_pause_time()


func _pause_time():
	get_tree().paused = !get_tree().paused
	$half_black.visible = !$half_black.visible
	
func _on_Button_pressed() -> void:
	_pause_time()

