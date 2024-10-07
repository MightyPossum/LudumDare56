extends Panel


func _on_back_to_main_pressed() -> void:
	$MenuClick.play()
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
