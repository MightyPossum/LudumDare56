extends Control

@onready var bosses_left: Label = %BossesLeft
@onready var attempt_tracker: Label = %AttemptTracker
@onready var ally_tracker: Label = %CreatureTracker
@onready var gold: Label = %Gold

var boost_on_cooldown : bool = false
var shield_on_cooldown : bool = false
var in_upgrade_menu : bool = false

var tween : Tween

func _ready():
	GLOBALVARIABLES.main_ui = self
	set_stats_visibility(false)
	set_speed_buttons()

func _process(_delta):
	bosses_left.text = "Bosses Left: " + str(GLOBALVARIABLES.bosses_left)
	attempt_tracker.text = "Attampt Nr: " + str(GLOBALVARIABLES.round_counter)
	ally_tracker.text = "Creatures Left: " + str(GLOBALVARIABLES.ally_count)
	gold.text = "Gold: " + str(GLOBALVARIABLES.player_resource)

func _on_start_wave_button_button_up() -> void:
	%MenuPressed.play()
	GLOBALVARIABLES.game_manager.start_wave()
	GLOBALVARIABLES.main_ui.set_upgrade_panel_visibility(false)
	GLOBALVARIABLES.main_ui.set_start_wave_button_visibility(false)
	GLOBALVARIABLES.main_ui.set_stats_visibility(true)

func set_stats_visibility(toggle: bool):
	%StatsContainer.visible = toggle
	%GodPowers.visible = toggle
	%BoostPower.disabled = true
	%ShieldPower.disabled = true
	await get_tree().create_timer(2, false,true).timeout
	toggle_powers('null', true)

func set_start_wave_button_visibility(toggle: bool):
	%StartWaveButton.visible = toggle

func set_upgrade_panel_visibility(toggle: bool):
	%UpgradePanel.visible = toggle
	in_upgrade_menu = toggle
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
	toggle_powers(power_type, false)
	await get_tree().create_timer(delay_time, false,true).timeout
	toggle_powers(power_type, true)

func handle_power(power_type : String, delay_time : float) -> void:
	match power_type:
		"boost":
			EVENTS.boost_activated.emit(delay_time)
		"shield":
			EVENTS.shield_activated.emit(delay_time)

func toggle_powers(power_type : String, apply_cooldown : bool) -> void:
	if apply_cooldown:
		if power_type != "boost" and GLOBALVARIABLES.boost_power_unlocked and not boost_on_cooldown:
			%BoostPower.disabled = false
		elif not GLOBALVARIABLES.boost_power_unlocked:
			%BoostPower.disabled = true

		if power_type != "shield" and GLOBALVARIABLES.shield_power_unlocked and not shield_on_cooldown:
			%ShieldPower.disabled = false
		elif not GLOBALVARIABLES.shield_power_unlocked:
			%ShieldPower.disabled = true

	else:
		%BoostPower.disabled = true
		%ShieldPower.disabled = true

	# we do this last, because of await
	if apply_cooldown and power_type == "boost" and GLOBALVARIABLES.boost_power_unlocked:
		boost_on_cooldown = true

		var boost_progress_bar =%BoostProgressBar
		boost_progress_bar.visible = true
		boost_progress_bar.value = 0
		tween = get_tree().create_tween()
		tween.tween_property(boost_progress_bar, "value", 30, 30)
		tween.tween_callback(timer_done.bind(power_type))

	elif apply_cooldown and power_type == "shield" and GLOBALVARIABLES.shield_power_unlocked:
		shield_on_cooldown = true
		var shield_progress_bar =%ShieldProgressBar
		shield_progress_bar.visible = true
		shield_progress_bar.value = 0
		tween = get_tree().create_tween()
		tween.tween_property(shield_progress_bar, "value", 30, 30)
		tween.tween_callback(timer_done.bind(power_type))

func timer_done(power_type : String) -> void:
	if power_type == "shield":
		%ShieldProgressBar.visible = false
		shield_on_cooldown = false
		%ShieldPower.disabled = false
	elif power_type == "boost":
		%BoostProgressBar.visible = false
		boost_on_cooldown = false
		%BoostPower.disabled = false


func update_lables() -> void:
	if in_upgrade_menu:
		%UpgradePanel.update_lables()

func update_gold_ui() -> void:
	if in_upgrade_menu:
		%UpgradePanel.update_gold_label()

func set_speed_buttons() -> void:
	if Engine.time_scale == 1:
		%PlayButton.disabled = true
		%FFButton.disabled = false
	elif Engine.time_scale == 2:
		%PlayButton.disabled = false
		%FFButton.disabled = true
	
func set_speed() -> void:
	if Engine.time_scale <= 1:
		Engine.time_scale = 2
	
	elif Engine.time_scale >= 2:
		Engine.time_scale = 1

	set_speed_buttons() 
