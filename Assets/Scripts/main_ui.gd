extends Control

func _on_start_wave_button_button_up() -> void:
	GLOBALVARIABLES.game_manager.start_wave()

func set_start_wave_button_visibility(toggle : bool):
	%StartWaveButton.visible = toggle
