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
		"range" : 15,
		"damage" : 1,
		"attack_speed" : 1,
		"summon_amount" : 1,
	},
	CREATURE_TYPES.IMP : {
		"health" : 100,
		"movement_speed" : 100,
		"range" : 15,
		"damage" : 1,
		"attack_speed" : 2,
		"summon_amount" : 0,
	},
	CREATURE_TYPES.GHOST : {
		"health" : 100,
		"movement_speed" : 100,
		"range" : 15,
		"damage" : 1,
		"attack_speed" : 1,
		"summon_amount" : 0,
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

func adjust_creature_default(creature_type: CREATURE_TYPES, key: String, value):
	if creature_type in creature_defaults:
		creature_defaults[creature_type][key] += value
		print("Updated ", creature_type, key, " to ", value)
		print(creature_defaults[creature_type])
		print("Creature type:", CREATURE_TYPES.keys()[creature_type])
	else:
		print("Creature type not found:", creature_type)
