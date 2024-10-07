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
@onready var labels_current_stats: Dictionary = {
	%SlimeHpUpgradeNow: [GLOBALVARIABLES.CREATURE_TYPES.SLIME, "health"],
	%SlimeSummonUpgradeNow: [GLOBALVARIABLES.CREATURE_TYPES.SLIME, "summon_amount"],
	%SlimeDmgUpgradeNow: [GLOBALVARIABLES.CREATURE_TYPES.SLIME, "damage"],
	%SlimeAsUpgradeNow: [GLOBALVARIABLES.CREATURE_TYPES.SLIME, "attack_speed"],

	%ImpHpUpgradeNow: [GLOBALVARIABLES.CREATURE_TYPES.IMP, "health"],
	%ImpSummonUpgradeNow: [GLOBALVARIABLES.CREATURE_TYPES.IMP, "summon_amount"],
	%ImpDmgUpgradeNow: [GLOBALVARIABLES.CREATURE_TYPES.IMP, "damage"],
	%ImpAsUpgradeNow: [GLOBALVARIABLES.CREATURE_TYPES.IMP, "attack_speed"],

	%GhostHpUpgradeNow: [GLOBALVARIABLES.CREATURE_TYPES.GHOST, "health"],
	%GhostSummonUpgradeNow: [GLOBALVARIABLES.CREATURE_TYPES.GHOST, "summon_amount"],
	%GhostDmgUpgradeNow: [GLOBALVARIABLES.CREATURE_TYPES.GHOST, "damage"],
	%GhostAsUpgradeNow: [GLOBALVARIABLES.CREATURE_TYPES.GHOST, "attack_speed"],
}
@onready var labels_upgrade_stats: Dictionary = {
	%SlimeHpUpgradeFuture: [GLOBALVARIABLES.CREATURE_TYPES.SLIME, "health"],
	%SlimeSummonUpgradeFuture: [GLOBALVARIABLES.CREATURE_TYPES.SLIME, "summon_amount"],
	%SlimeDmgUpgradeFuture: [GLOBALVARIABLES.CREATURE_TYPES.SLIME, "damage"],
	%SlimeAsUpgradeFuture: [GLOBALVARIABLES.CREATURE_TYPES.SLIME, "attack_speed"],

	%ImpHpUpgradeFuture: [GLOBALVARIABLES.CREATURE_TYPES.IMP, "health"],
	%ImpSummonUpgradeFuture: [GLOBALVARIABLES.CREATURE_TYPES.IMP, "summon_amount"],
	%ImpDmgUpgradeFuture: [GLOBALVARIABLES.CREATURE_TYPES.IMP, "damage"],
	%ImpAsUpgradeFuture: [GLOBALVARIABLES.CREATURE_TYPES.IMP, "attack_speed"],

	%GhostHpUpgradeFuture: [GLOBALVARIABLES.CREATURE_TYPES.GHOST, "health"],
	%GhostSummonUpgradeFuture: [GLOBALVARIABLES.CREATURE_TYPES.GHOST, "summon_amount"],
	%GhostDmgUpgradeFuture: [GLOBALVARIABLES.CREATURE_TYPES.GHOST, "damage"],
	%GhostAsUpgradeFuture: [GLOBALVARIABLES.CREATURE_TYPES.GHOST, "attack_speed"],
}
@onready var labels_upgrade_costs: Dictionary = {
	%SlimeHpUpgradeCost: [GLOBALVARIABLES.CREATURE_TYPES.SLIME, "health"],
	%SlimeSummonCost: [GLOBALVARIABLES.CREATURE_TYPES.SLIME, "summon_amount"],
	%SlimeDmgCost: [GLOBALVARIABLES.CREATURE_TYPES.SLIME, "damage"],
	%SlimeAsCost: [GLOBALVARIABLES.CREATURE_TYPES.SLIME, "attack_speed"],

	%ImpHpCost: [GLOBALVARIABLES.CREATURE_TYPES.IMP, "health"],
	%ImpSummonCost: [GLOBALVARIABLES.CREATURE_TYPES.IMP, "summon_amount"],
	%ImpDmgCost: [GLOBALVARIABLES.CREATURE_TYPES.IMP, "damage"],
	%ImpAsCost: [GLOBALVARIABLES.CREATURE_TYPES.IMP, "attack_speed"],

	%GhostHpCost: [GLOBALVARIABLES.CREATURE_TYPES.GHOST, "health"],
	%GhostSummonCost: [GLOBALVARIABLES.CREATURE_TYPES.GHOST, "summon_amount"],
	%GhostDmgCost: [GLOBALVARIABLES.CREATURE_TYPES.GHOST, "damage"],
	%GhostAsCost: [GLOBALVARIABLES.CREATURE_TYPES.GHOST, "attack_speed"],
	
	%BoostCost: [GLOBALVARIABLES.CREATURE_TYPES.GOD, "boost"],
	%ShieldCost: [GLOBALVARIABLES.CREATURE_TYPES.GOD, "shield"],
}
@onready var god_power_factor_labels: Dictionary = {
	"boost_power_factor": %BoostFactorUpgradeNow,
	"boost_power_time": %BoostTimeUpgradeNow,
	"boost_power_factor_upgrade": %BoostFactorUpgradeFuture,
	"boost_power_time_upgrade": %BoostTimeUpgradeFuture,
	"shield_power_time": %ShieldUpgradenow,
	"shield_power_time_upgrade": %ShieldUpgradeFuture
}

func _ready():
	update_upgrade_costs()
	update_lables()

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
			GLOBALVARIABLES.adjust_creature_default(creature, "health")
		2:
			GLOBALVARIABLES.adjust_creature_default(creature, "summon_amount")
		3:
			GLOBALVARIABLES.adjust_creature_default(creature, "damage")
		4:
			GLOBALVARIABLES.adjust_creature_default(creature, "attack_speed")
			
	update_lables()
	update_upgrade_costs()


func update_gold_label():
	gold_lable.text = str("Gold: " + str(GLOBALVARIABLES.player_resource))

func _on_god_upgrade_pressed(power_type:String) -> void:
	%MenuClick.play()
	GLOBALVARIABLES.handle_god_power_upgrade(power_type)
	update_upgrade_costs()
	update_lables()

func update_upgrade_costs():
	update_gold_label()
	for button in buttons:
		var upgrade_cost = GLOBALVARIABLES.creature_upgrade_costs.get(buttons[button][0]).get(buttons.get(button)[1])
		if upgrade_cost > GLOBALVARIABLES.player_resource:
			button.disabled = true
		else:

			if buttons[button][1] == "attack_speed":
				if GLOBALVARIABLES.creature_defaults.get(buttons[button][0]).get("attack_speed") <= 0.12:
					button.disabled = true
				else:
					button.disabled = false
			
			if buttons[button][0] <= 2 and buttons[button][1] != "summon_amount":
				if not GLOBALVARIABLES.creature_defaults.get(buttons[button][0]).get("summon_amount"):
					button.disabled = true
				else:
					button.disabled = false		

func update_lables():
	for label in labels_current_stats:
		label.text = str(GLOBALVARIABLES.creature_defaults.get(labels_current_stats[label][0]).get(labels_current_stats[label][1]))

	for label in labels_upgrade_stats:
		label.text = str(GLOBALVARIABLES.creature_defaults.get(labels_upgrade_stats[label][0]).get(labels_upgrade_stats[label][1]) + GLOBALVARIABLES.creature_upgrade_amount.get(labels_upgrade_stats[label][0]).get(labels_upgrade_stats[label][1]))

	for label in labels_upgrade_costs:
		var cost = GLOBALVARIABLES.creature_upgrade_costs.get(labels_upgrade_costs[label][0]).get(labels_upgrade_costs[label][1])
		if cost > 10000:
			cost = str(cost / 1000) + "k"
		else:
			cost = str(cost)
		label.text = "Cost: " + cost
		
	if GLOBALVARIABLES.boost_power_unlocked:
		god_power_factor_labels["boost_power_factor"].show()
		god_power_factor_labels["boost_power_time"].show()
		god_power_factor_labels["boost_power_factor_upgrade"].show()
		god_power_factor_labels["boost_power_time_upgrade"].show()
		
		god_power_factor_labels["boost_power_factor"].text = str(GLOBALVARIABLES.boost_power_factor)
		god_power_factor_labels["boost_power_time"].text = str(GLOBALVARIABLES.boost_power_time)
		god_power_factor_labels["boost_power_factor_upgrade"].text = str(GLOBALVARIABLES.boost_power_factor + GLOBALVARIABLES.boost_power_factor_upgrade)
		god_power_factor_labels["boost_power_time_upgrade"].text = str(GLOBALVARIABLES.boost_power_time + GLOBALVARIABLES.boost_power_time_upgrade)
	else:
		god_power_factor_labels["boost_power_factor"].hide()
		god_power_factor_labels["boost_power_time"].hide()
		god_power_factor_labels["boost_power_factor_upgrade"].hide()
		god_power_factor_labels["boost_power_time_upgrade"].hide()

	if GLOBALVARIABLES.shield_power_unlocked:
		god_power_factor_labels["shield_power_time"].show()
		god_power_factor_labels["shield_power_time_upgrade"].show()

		god_power_factor_labels["shield_power_time"].text = str(GLOBALVARIABLES.shield_power_time)
		god_power_factor_labels["shield_power_time_upgrade"].text = str(GLOBALVARIABLES.shield_power_time + GLOBALVARIABLES.shield_power_time_upgrade)
	else :
		god_power_factor_labels["shield_power_time"].hide()
		god_power_factor_labels["shield_power_time_upgrade"].hide()
