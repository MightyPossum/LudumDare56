extends Button

func _on_pressed() -> void:
	%MenuClick.play()
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
