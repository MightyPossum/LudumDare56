extends Control

@onready var bosses_left: Label = %BossesLeft
@onready var attempt_tracker: Label = %AttemptTracker
@onready var ally_tracker: Label = %CreatureTracker
@onready var gold: Label = %Gold

func _ready():
	GLOBALVARIABLES.main_ui = self
	set_stats_visibility(false)

func _process(_delta):
	bosses_left.text = "Bosses Left: " + str(GLOBALVARIABLES.bosses_left)
	attempt_tracker.text = "Attampt Nr: " + str(GLOBALVARIABLES.round_counter)
	ally_tracker.text = "Creatures Left: " + str(GLOBALVARIABLES.ally_count)
	gold.text = "Gold: " + str(GLOBALVARIABLES.player_resource)

	
func _on_start_wave_button_button_up() -> void:
	GLOBALVARIABLES.game_manager.start_wave()
	GLOBALVARIABLES.main_ui.set_upgrade_panel_visibility(false)
	GLOBALVARIABLES.main_ui.set_start_wave_button_visibility(false)
	GLOBALVARIABLES.main_ui.set_stats_visibility(true)

func set_stats_visibility(toggle: bool):
	%StatsContainer.visible = toggle
	%GodPowers.visible = toggle
	%BoostPower.disabled = true
	%ShieldPower.disabled = true
	await get_tree().create_timer(2).timeout
	toggle_powers()

func set_start_wave_button_visibility(toggle: bool):
	%StartWaveButton.visible = toggle

func set_upgrade_panel_visibility(toggle: bool):
	%UpgradePanel.visible = toggle
	%UpgradePanel.update_gold_label()
	
func _on_power_up_pressed(power_type : String) -> void:
	var delay_time : float
	match power_type:
		"boost":
			delay_time = GLOBALVARIABLES.boost_power_time
		"shield":
			delay_time = GLOBALVARIABLES.shield_power_time
	%GodPowerActivation.play()

	
	handle_power(power_type, delay_time)
	toggle_powers()
	await get_tree().create_timer(GLOBALVARIABLES.god_power_cooldown_time).timeout
	toggle_powers()

func handle_power(power_type : String, delay_time : float) -> void:
	match power_type:
		"boost":
			EVENTS.boost_activated.emit(delay_time)
		"shield":
			EVENTS.shield_activated.emit(delay_time)

func toggle_powers() -> void:
	if not GLOBALVARIABLES.boost_power_unlocked:
		%BoostPower.disabled = true
	else:
		%BoostPower.disabled = !%BoostPower.disabled
	
	if not GLOBALVARIABLES.shield_power_unlocked:
		%ShieldPower.disabled = true
	else:
		%ShieldPower.disabled = !%ShieldPower.disabled

func update_upgrade_costs() -> void:
	%UpgradePanel.update_upgrade_costs()
