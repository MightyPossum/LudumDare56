extends Resource
class_name SaveGameData

@export var save_name : String

@export var creature_defaults : Dictionary = {}
@export var creature_upgrade_costs : Dictionary = {}
@export var creature_upgrade_amount : Dictionary = {}
@export var boost_power_factor : float
@export var boost_power_time : float
@export var boost_power_unlocked : bool
@export var shield_power_time : float
@export var shield_power_unlocked : bool
@export var round_counter : int
@export var player_resource : int

func save_data() -> void:
	
	save_name = SaveGame.save_config.get_current_save_file().split(".")[0]
	creature_defaults = GLOBALVARIABLES.creature_defaults.duplicate(true)
	creature_upgrade_costs = GLOBALVARIABLES.creature_upgrade_costs.duplicate(true)
	creature_upgrade_amount = GLOBALVARIABLES.creature_upgrade_amount.duplicate(true)
	boost_power_factor = GLOBALVARIABLES.boost_power_factor
	boost_power_time = GLOBALVARIABLES.boost_power_time
	boost_power_unlocked = GLOBALVARIABLES.boost_power_unlocked
	shield_power_time = GLOBALVARIABLES.shield_power_time
	shield_power_unlocked = GLOBALVARIABLES.shield_power_unlocked
	round_counter = GLOBALVARIABLES.round_counter
	player_resource = GLOBALVARIABLES.player_resource
	

# Currently just overwrites all quest data
func load_data() -> void:
	
	GLOBALVARIABLES.creature_defaults = creature_defaults.duplicate(true)
	GLOBALVARIABLES.creature_upgrade_costs = creature_upgrade_costs.duplicate(true)
	GLOBALVARIABLES.creature_upgrade_amount = creature_upgrade_amount.duplicate(true)
	GLOBALVARIABLES.boost_power_factor = boost_power_factor
	GLOBALVARIABLES.boost_power_time = boost_power_time
	GLOBALVARIABLES.boost_power_unlocked = boost_power_unlocked
	GLOBALVARIABLES.shield_power_time = shield_power_time
	GLOBALVARIABLES.shield_power_unlocked = shield_power_unlocked
	GLOBALVARIABLES.round_counter = round_counter 
	GLOBALVARIABLES.player_resource = player_resource
