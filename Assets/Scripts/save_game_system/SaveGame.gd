extends Node

const USER_DATA_PATH: String = "user://save/"
const CONFIG_FILE_NAME: String = "TinyConfig"
const SAVE_PATH_EXTENSION : String = ".tres"

var save_game_data = SaveGameData.new()
var save_config = SaveConfig.new()
var reset_in_progress: bool = false

func _ready() -> void:
	verify_save_directory(USER_DATA_PATH)
	
	load_master_config_file()


func on_menu_initialized() -> void:
	if not save_config.get_current_save_file():
		GLOBALVARIABLES.main_menu_node.set_load_button_active_status(true)

func save_master_config_file() -> void:
	save_config.set_save_file_details()
	print(ResourceSaver.save(save_config, USER_DATA_PATH + CONFIG_FILE_NAME + SAVE_PATH_EXTENSION))
	
func load_master_config_file() -> void:
	if not ResourceLoader.exists(USER_DATA_PATH + CONFIG_FILE_NAME + SAVE_PATH_EXTENSION):
		save_master_config_file()

	save_config = ResourceLoader.load(USER_DATA_PATH + CONFIG_FILE_NAME + SAVE_PATH_EXTENSION, "", ResourceLoader.CACHE_MODE_IGNORE).duplicate(true)

func continue_game() -> void:
	var save_file_name : String = save_config.get_current_save_file()
	load_data(save_file_name)

func start_new_game() -> void:
	var index = save_config.add_save_file("TinySaveGame" + str(save_config.get_save_file_count() + 1) + ".tres")
	save_config.set_current_save_file(save_config.get_save_file_at_index(index))
	save_game()

## Saves to the actual file
func save_to_file() -> void:
	print(USER_DATA_PATH + save_config.get_current_save_file())
	print(ResourceSaver.save(save_game_data, USER_DATA_PATH + save_config.get_current_save_file()))

func load_from_file() -> void:
	save_game_data = ResourceLoader.load(USER_DATA_PATH + save_config.get_current_save_file()).duplicate(true)

## Loads data from the actual file
func load_data(save_file_path) -> void:
	save_config.set_current_save_file(save_file_path)
	load_from_file()
	save_game_data.load_data()

## verify that the save directory is available
func verify_save_directory(path : String) -> void:
	DirAccess.make_dir_absolute(path)

func save_game() -> void:

	save_game_data.save_data()

	save_master_config_file()
	print("saving to file")
	save_to_file()

func change_current_save(save_path : String) -> void:
	save_config.set_current_save_file(save_path + SAVE_PATH_EXTENSION)
