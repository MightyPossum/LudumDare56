extends Node

enum CREATURE_TYPES {
    SLIME,
    GOBLIN,
}

var creature_manager = {}

var creature_defaults = {
    CREATURE_TYPES.SLIME : {
        "health" : 10,
        "movement_speed" : 50,
        "range" : 15,
        "damage" : 1,
        "attack_speed" : 5,
        "summon_amount" : 1,
    },
    CREATURE_TYPES.GOBLIN : {
        "health" : 10,
        "movement_speed" : 50,
        "range" : 15,
        "damage" : 1,
        "attack_speed" : 5,
        "summon_amount" : 0,
    },
    }

var game_manager : Node2D
var main_ui : Control

var ally_count = 0
var upgrade_chosen: bool = false
var round_counter: int = 0
var player_resource: int = 0

#INFO: Creature Stats
var player_creature_max_health : int = 100
var player_creature_count : int  = 1
