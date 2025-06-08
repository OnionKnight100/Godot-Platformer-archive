extends Node

const file_name = "user://save.json"
var data = {};

func _ready() -> void:
	load_data()
	

func load_data():
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, file.READ)
		var text = file.get_as_text()
		data = parse_json(text)
		file.close()
	else:
		print("no file here")
		data = {"player":
			   {"position":
			   {"pos_x":-96, "pos_y":784},
			   "attributes":
			   {"health":100, "max_hp":100}}}
		

func save_data():
	var file = File.new()
	file.open(file_name, File.WRITE)
	file.store_line(to_json(data))
	file.close()
	print("data_saved")
