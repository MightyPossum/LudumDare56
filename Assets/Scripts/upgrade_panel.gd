extends Control

@onready var grid_container: GridContainer = $PanelContainer/GridContainer

func _on_hp_upgrade_pressed() -> void:
	var add_hp: int  = 10
	#GLOBALVARIABLES.player_creature_max_health += add_hp
	GLOBALVARIABLES.main_ui.set_upgrade_panel_visibility(false)
	GLOBALVARIABLES.main_ui.set_start_wave_button_visibility(true)

func _on_ally_upgrade_pressed() -> void:
	var add_to_ally_count: int = 1
	#GLOBALVARIABLES.player_creature_count += add_to_ally_count
	visible = false
	GLOBALVARIABLES.main_ui.set_upgrade_panel_visibility(false)
	GLOBALVARIABLES.main_ui.set_start_wave_button_visibility(true)
