extends Control

@onready var gold_lable: Label = %Gold
@onready var buttons: Array = [
	%HpUpgradeSlime, %AllyUpgradeSlime, %DamageUpgradeSlime, %AttackSpeedUpgradeSlime,
	%HpUpgradeImp, %AllyUpgradeImp, %DamageUpgradeImp, %AttackSpeedUpgradeImp, 
	%HpUpgradeGhost, %AllyUpgradeGhost, %DamageUpgradeGhost, %AttackSpeedUpgradeGhost
	]

var gold = GLOBALVARIABLES.player_resource

func _on_upgrade_pressed(creature: String, upgrade: int) -> void:
	%MenuClick.play()
	match creature:
		"Slime":
			upgrade_type(upgrade, GLOBALVARIABLES.CREATURE_TYPES.SLIME)
		"Imp":
			upgrade_type(upgrade, GLOBALVARIABLES.CREATURE_TYPES.IMP)
		"Ghost":
			upgrade_type(upgrade, GLOBALVARIABLES.CREATURE_TYPES.GHOST)

	update_gold_label()

func upgrade_type(upgrade: int, creature: GLOBALVARIABLES.CREATURE_TYPES) -> void:
	match upgrade:
		1:
			GLOBALVARIABLES.adjust_creature_default(creature, "health", 10)
		2:
			GLOBALVARIABLES.adjust_creature_default(creature, "summon_amount", 1)
		3:
			GLOBALVARIABLES.adjust_creature_default(creature, "damage", 1)
		4:
			GLOBALVARIABLES.adjust_creature_default(creature, "attack_speed", 2)

func update_gold_label():
	gold_lable.text = str("Gold: " + str(GLOBALVARIABLES.player_resource))
