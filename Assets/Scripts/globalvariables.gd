extends Node

var game_manager : Node2D
var main_ui : Control

var ally_count = 0
var upgrade_chosen: bool = false
var round_counter: int = 0


#INFO: Creature Stats
var player_creature_max_health : int = 100
var player_creature_count : int  = 1
