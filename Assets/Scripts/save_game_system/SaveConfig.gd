extends Resource
class_name SaveConfig

@export var save_files: Array = []
@export var save_file_details : Dictionary = {}
@export var current_save_file : String 
@export var save_location : String

func add_save_file(save_file_path : String) -> int:
	save_files.append(save_file_path)
	return save_files.find(save_file_path)

func set_save_file_details() -> void:
	if current_save_file:
		save_file_details[current_save_file] = {"gameName" : current_save_file.split(".", false)[0],"gameTime":666,"dateTime": Time.get_datetime_string_from_system()}

func remove_save_file(save_file_index: int) -> void:
	save_files.erase(save_file_index)

func get_save_file_paths() -> Array:
	return save_files.duplicate()

func get_save_file_at_index(index : int) -> String:
	return save_files[index]

func get_save_file_count() -> int:
	return save_files.size()

func set_current_save_file(_current_save_file : String) -> void:
	current_save_file = _current_save_file

func get_current_save_file() -> String:
	return current_save_file

func get_save_game_details(save_path) -> Dictionary:
	return save_file_details.get(save_path)