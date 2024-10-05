extends Control

@onready var gold: Label = $BoxContainer/Gold

func _on_hp_upgrade_pressed() -> void:
	var add_hp: int  = 10
	#GLOBALVARIABLES.player_creature_max_health += add_hp


func _on_ally_upgrade_pressed() -> void:
	var add_to_ally_count: int = 1
	#GLOBALVARIABLES.player_creature_count += add_to_ally_count

func update_gold_label():
	gold.text = str("Gold: " + str(GLOBALVARIABLES.player_resource))
