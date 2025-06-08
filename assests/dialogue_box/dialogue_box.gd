extends CanvasLayer

export(String, FILE, "*.json") var dialogue_file 
var dialogues = []
var current_line = 0
var active = false
var timer_finished = true


func _ready() -> void:
	$NinePatchRect.visible = false

func play_dialogue():
	dialogues = get_dialogues()
	current_line = -1
	$NinePatchRect.visible = true
	play_next_line()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		if active == true:
			play_next_line()

func play_next_line():
	current_line += 1
	if current_line >= len(dialogues):
		var parent = get_parent()
		parent._interaction_finished()
		$NinePatchRect.visible = false
	else:
		$NinePatchRect/dialogue.text = ""
		$NinePatchRect/name.text = dialogues[current_line]["name"]
		#$NinePatchRect/dialogue.text = dialogues[current_line]["text"]
		_print_onebyone(dialogues[current_line]["text"])

func get_dialogues():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file ,file.READ)
		return parse_json(file.get_as_text())


func _print_onebyone(input_text):
	var text
	text = input_text
	for i in text:
		print(i)
		$Timer.start()
		$NinePatchRect/dialogue.add_text(i)
		yield($Timer , "timeout")


