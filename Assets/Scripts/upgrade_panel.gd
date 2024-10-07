extends Control

@onready var gold_lable: Label = %Gold
@onready var buttons: Dictionary = {
	%HpUpgradeSlime : [GLOBALVARIABLES.CREATURE_TYPES.SLIME , "health"],
	%AllyUpgradeSlime : [GLOBALVARIABLES.CREATURE_TYPES.SLIME , "summon_amount"],
	%DamageUpgradeSlime : [GLOBALVARIABLES.CREATURE_TYPES.SLIME , "damage"],
	%AttackSpeedUpgradeSlime : [GLOBALVARIABLES.CREATURE_TYPES.SLIME , "attack_speed"],
	%HpUpgradeImp : [GLOBALVARIABLES.CREATURE_TYPES.IMP , "health"],
	%AllyUpgradeImp : [GLOBALVARIABLES.CREATURE_TYPES.IMP , "summon_amount"],
	%DamageUpgradeImp : [GLOBALVARIABLES.CREATURE_TYPES.IMP , "damage"],
	%AttackSpeedUpgradeImp : [GLOBALVARIABLES.CREATURE_TYPES.IMP , "attack_speed"],
	%HpUpgradeGhost : [GLOBALVARIABLES.CREATURE_TYPES.GHOST , "health"],
	%AllyUpgradeGhost : [GLOBALVARIABLES.CREATURE_TYPES.GHOST , "summon_amount"],
	%DamageUpgradeGhost : [GLOBALVARIABLES.CREATURE_TYPES.GHOST , "damage"],
	%AttackSpeedUpgradeGhost : [GLOBALVARIABLES.CREATURE_TYPES.GHOST , "attack_speed"],
	%EmpowerUpgrade : [GLOBALVARIABLES.CREATURE_TYPES.GOD , "boost"],
	%ShieldUpgrade : [GLOBALVARIABLES.CREATURE_TYPES.GOD , "shield"],
}

func _ready():
	update_upgrade_costs()

func _on_upgrade_pressed(creature: String, upgrade: int) -> void:
	%MenuClick.play()
	match creature:
		"Slime":
			upgrade_type(upgrade, GLOBALVARIABLES.CREATURE_TYPES.SLIME)
		"Imp":
			upgrade_type(upgrade, GLOBALVARIABLES.CREATURE_TYPES.IMP)
		"Ghost":
			upgrade_type(upgrade, GLOBALVARIABLES.CREATURE_TYPES.GHOST)

func upgrade_type(upgrade: int, creature: GLOBALVARIABLES.CREATURE_TYPES) -> void:
	match upgrade:
		1:
			GLOBALVARIABLES.adjust_creature_default(creature, "health", 50)
		2:
			GLOBALVARIABLES.adjust_creature_default(creature, "summon_amount", 1)
		3:
			GLOBALVARIABLES.adjust_creature_default(creature, "damage", 2)
		4:
			GLOBALVARIABLES.adjust_creature_default(creature, "attack_speed", -0.05)

func update_gold_label():
	gold_lable.text = str("Gold: " + str(GLOBALVARIABLES.player_resource))

func _on_god_upgrade_pressed(power_type:String) -> void:
	GLOBALVARIABLES.handle_god_power_upgrade(power_type)

func update_upgrade_costs():
	update_gold_label()
	for button in buttons:
		print(button)
		print(buttons[button])
		print(buttons[button][1])
		var power_cost = GLOBALVARIABLES.creature_upgrade_costs.get(buttons[button][0]).get(buttons.get(button)[1])
		if power_cost > GLOBALVARIABLES.player_resource:
			button.disabled = true
		elif buttons[button][0] <= 2:
			if buttons[button][1] != "summon_amount" and not GLOBALVARIABLES.creature_defaults.get(buttons[button][0]).get("summon_amount"):
				button.disabled = true

	#	button.text = str(GLOBALVARIABLES.creature_upgrade_costs.get(buttons[button][0]).get(buttons.get(button)[1]))
