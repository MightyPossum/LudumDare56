extends MarginContainer

func _on_new_game_pressed() -> void:
	pass # Replace with function body.


func _on_load_game_pressed() -> void:
	pass # Replace with function body.


func _on_how_to_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/how_to.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().quit()
