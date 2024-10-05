extends Control

func _ready():
	GLOBALVARIABLES.main_ui = self

func _on_start_wave_button_button_up() -> void:
	GLOBALVARIABLES.game_manager.start_wave()

func set_start_wave_button_visibility(toggle : bool):
	%StartWaveButton.visible = toggle

func set_upgrade_panel_visibility(toggle : bool):
	%UpgradePanel.visible = toggle
