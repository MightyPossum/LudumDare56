extends Node2D

var ongoing_wave = false

@export var distance_to_enemy = 20
@onready var main_ui : Control = %MainUI

func _ready():
	GLOBALVARIABLES.game_manager = self
	if GLOBALVARIABLES.round_counter >= 1:
		main_ui.set_upgrade_panel_visibility(true)
		main_ui.set_start_wave_button_visibility(false)
	else:
		main_ui.set_upgrade_panel_visibility(false)
		main_ui.set_start_wave_button_visibility(true)

func _process(_delta):
	if ongoing_wave:
		if GLOBALVARIABLES.ally_count <= 0:
			lose()

func get_enemy_base_location() -> Vector2:
	return get_node("EnemyBase").global_position

func win() -> void:
	get_tree().quit()
	

func lose() -> void:
	print("You lose!")
	GLOBALVARIABLES.round_counter += 1
	get_tree().reload_current_scene()
	
func start_wave() -> void:
	main_ui.set_start_wave_button_visibility(false)
	ongoing_wave = true
	spawn_creatures()

func spawn_creatures() -> void:
	for i in range(0,GLOBALVARIABLES.player_creature_count):
		print(%spawnArea.shape.get_size())
		GLOBALVARIABLES.ally_count += 1
		#var top_left = %spawnArea.global_position
		#var bottom_right = %spawnArea.global_position.x - %spawnArea.transform.

func _on_bass_range_body_entered(_body: Node2D) -> void:
	win()
