extends Control

@onready var gold_lable: Label = %Gold

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
	
	%EmpowerCost: [GLOBALVARIABLES.CREATURE_TYPES.GOD, "boost"],
	%ShieldCost: [GLOBALVARIABLES.CREATURE_TYPES.GOD, "shield"],
}

func _ready():
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


func update_gold_label():
	gold_lable.text = str("Gold: " + str(GLOBALVARIABLES.player_resource))

func _on_god_upgrade_pressed(power_type:String) -> void:
	GLOBALVARIABLES.handle_god_power_upgrade(power_type)
	update_lables()

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
