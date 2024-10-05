extends Control

@onready var bosses_left: Label = $BoxContainer/BossesLeft
@onready var attempt_tracker: Label = $BoxContainer/AttemptTracker
@onready var ally_tracker: Label = $BoxContainer/AllyTracker

func _ready():
	GLOBALVARIABLES.main_ui = self

func _on_start_wave_button_button_up() -> void:
	GLOBALVARIABLES.game_manager.start_wave()

func set_start_wave_button_visibility(toggle : bool):
	%StartWaveButton.visible = toggle

func set_upgrade_panel_visibility(toggle : bool):
	%UpgradePanel.visible = toggle
	%UpgradePanel.update_gold_label()
	
func update_player_labls():
	bosses_left.text = str("Bosses Left: " + GLOBALVARIABLES.bosses_left)
	attempt_tracker.text = str("Attampt Nr: " + GLOBALVARIABLES.attempt_tracker)
	ally_tracker.text = str("Allys Left: " + GLOBALVARIABLES.ally_tracker)
