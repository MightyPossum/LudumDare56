extends MarginContainer

func _ready():
	GLOBALVARIABLES.main_menu_node = self
	SaveGame.on_menu_initialized()

func _on_new_game_pressed() -> void:
	SaveGame.start_new_game()
	get_tree().change_scene_to_file("res://Assets/Scenes/game_scene.tscn")


func _on_load_game_pressed() -> void:
	SaveGame.continue_game()
	get_tree().change_scene_to_file("res://Assets/Scenes/game_scene.tscn")


func _on_how_to_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/how_to.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().quit()


func set_load_button_active_status(toggle_value : bool) -> void:
	%LoadGame.disabled = toggle_value
