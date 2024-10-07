extends Resource
class_name SaveGameData

@export var save_name : String

@export var creature_defaults : Dictionary = {}


@export var round_counter : int
@export var player_resource : int

func save_data() -> void:
	
	save_name = SaveGame.save_config.get_current_save_file().split(".")[0]
	creature_defaults = GLOBALVARIABLES.creature_defaults.duplicate(true)
	round_counter = GLOBALVARIABLES.round_counter
	player_resource = GLOBALVARIABLES.player_resource
	

# Currently just overwrites all quest data
func load_data() -> void:
	
	GLOBALVARIABLES.creature_defaults = creature_defaults.duplicate(true)
	GLOBALVARIABLES.round_counter = round_counter 
	GLOBALVARIABLES.player_resource = player_resource
