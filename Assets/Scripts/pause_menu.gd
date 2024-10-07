extends Panel

func _ready():
	set_process_input(true)
	hide()

func _input(event):
	if event.is_action_pressed("Pause"):
		if self.visible:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true

func _on_continue_pressed() -> void:
	hide()
	get_tree().paused = false

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
