extends Node

enum CREATURE_TYPES {
	SLIME,
	IMP,
	GHOST,
}

var creature_manager = {}

var creature_defaults = {
	CREATURE_TYPES.SLIME : {
		"health" : 100,
		"movement_speed" : 100,
		"attack_range" : 100,
		"damage" : 10,
		"attack_speed" : 0.2,
		"summon_amount" : 0,
	},
	CREATURE_TYPES.IMP : {
		"health" : 100,
		"movement_speed" : 100,
		"attack_range" : 150,
		"damage" : 10,
		"attack_speed" : 0.2,
		"summon_amount" : 3,
	},
	CREATURE_TYPES.GHOST : {
		"health" : 100,
		"movement_speed" : 100,
		"attack_range" : 180,
		"damage" : 10,
		"attack_speed" : 0.2,
		"summon_amount" : 5,
	},
	}

var creature_upgrade_costs = {
	CREATURE_TYPES.SLIME : {
		"health" : 100,
		"summon_amount" : 100,
		"damage" : 100,
		"attack_speed" : 100,
	},
	CREATURE_TYPES.IMP : {
		"health" : 100,
		"summon_amount" : 100,
		"damage" : 100,
		"attack_speed" : 100,
	},
	CREATURE_TYPES.GHOST : {
		"health" : 100,
		"summon_amount" : 100,
		"damage" : 100,
		"attack_speed" : 100,
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
var boost_power_time : float = 1.5
var shield_power_time : float = 3