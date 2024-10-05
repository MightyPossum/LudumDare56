extends Node

enum CREATURE_TYPES {
	SLIME,
	IMP,
}

var creature_manager = {}

var creature_defaults = {
    CREATURE_TYPES.SLIME : {
        "health" : 100,
        "movement_speed" : 100,
        "range" : 15,
        "damage" : 1,
        "attack_speed" : 20,
        "summon_amount" : 1,
    },
    CREATURE_TYPES.IMP : {
        "health" : 100,
        "movement_speed" : 100,
        "range" : 15,
        "damage" : 1,
        "attack_speed" : 20,
        "summon_amount" : 1,
    },
    }

var game_manager : Node2D
var main_ui : Control

var upgrade_chosen: bool = false
var round_counter: int = 0
var bosses_left: int = 0
var player_resource: int = 0

var ally_count: int = 0