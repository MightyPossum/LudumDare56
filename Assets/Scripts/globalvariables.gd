extends Node

enum CREATURE_TYPES {
	SLIME,
	IMP,
	GHOST,
	GOD,
	ENEMY,
}

var creature_defaults = {
	CREATURE_TYPES.SLIME : {
		"health" : 30, #70
		"movement_speed" : 120,
		"attack_range" : 100,
		"damage" : 5,#10
		"attack_speed" : 0.5,
		"summon_amount" : 1,
	},
	CREATURE_TYPES.IMP : {
		"health" : 150,
		"movement_speed" : 110,
		"attack_range" : 200,
		"damage" : 25,
		"attack_speed" : 0.45,
		"summon_amount" : 0,
	},
	CREATURE_TYPES.GHOST : {
		"health" : 200,
		"movement_speed" : 100,
		"attack_range" : 250,
		"damage" : 40,
		"attack_speed" : 0.32,
		"summon_amount" : 0,
	},
	}

var creature_upgrade_costs = {
	CREATURE_TYPES.SLIME : {
		"health" : 1000, 
		"summon_amount" : 2500,
		"damage" : 1500,
		"attack_speed" : 5000,
	},
	CREATURE_TYPES.IMP : {
		"health" : 3000,
		"summon_amount" : 12500,
		"damage" : 4500,
		"attack_speed" : 15000,
	},
	CREATURE_TYPES.GHOST : {
		"health" : 15000,
		"summon_amount" : 45000,
		"damage" : 22500,
		"attack_speed" : 75000,
	},
	CREATURE_TYPES.GOD : {
		"boost" : 10000,
		"shield" : 10000,
	},
}

var creature_upgrade_amount = {
	CREATURE_TYPES.SLIME : {
		"health" : 100, 
		"summon_amount" : 1,
		"damage" : 2,
		"attack_speed" : -0.02,
	},
	CREATURE_TYPES.IMP : {
		"health" : 50,
		"summon_amount" : 1,
		"damage" : 4,
		"attack_speed" : -0.03,
	},
	CREATURE_TYPES.GHOST : {
		"health" : 75,
		"summon_amount" : 1,
		"damage" : 3,
		"attack_speed" : -0.035,
	},
}

var game_manager : Node2D
var main_ui : Control
var main_menu_node : Control

var upgrade_chosen: bool = false
var round_counter: int = 0
var bosses_left: int = 0
var player_resource: int = 0

var ally_count: int = 0

#god power upgrades
var boost_power_factor : float = 1.21
var boost_power_time : float = 3
var boost_power_unlocked : bool = false
var shield_power_time : float = 3
var shield_power_unlocked : bool = false

var god_power_cooldown_time = 30

func adjust_creature_default(creature_type: CREATURE_TYPES, key: String):
	
	if creature_defaults.get(creature_type):
		var upgrade_value = creature_upgrade_amount.get(creature_type).get(key)
		creature_defaults.get(creature_type)[key] += upgrade_value
		player_resource -= creature_upgrade_costs.get(creature_type)[key]
		creature_upgrade_costs.get(creature_type)[key] *= 2
	main_ui.update_upgrade_costs()

func handle_god_power_upgrade(power_type : String):
	player_resource -= creature_upgrade_costs.get(CREATURE_TYPES.GOD).get(power_type)

	if power_type == "boost":
		if not boost_power_unlocked:
			boost_power_unlocked = true
		else:
			boost_power_factor += 0.2
			boost_power_time += 1.5
		creature_upgrade_costs.get(CREATURE_TYPES.GOD).boost *= 2
	elif power_type == "shield":
		if not shield_power_unlocked:
			shield_power_unlocked = true
		else:
			shield_power_time += 1.5
		creature_upgrade_costs.get(CREATURE_TYPES.GOD).shield *= 2

	main_ui.update_upgrade_costs()