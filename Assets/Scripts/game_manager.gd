extends Node2D

@export var distance_to_enemy = 20
@onready var main_ui : Control = %MainUI

func _ready():
	GLOBALVARIABLES.game_manager = self

func get_enemy_base_location() -> Vector2:
	return get_node("EnemyBase").global_position

func start_wave() -> void:
	main_ui.set_start_wave_button_visibility(false)
	spawn_creatures()

func spawn_creatures() -> void:
	for i in range(0,GLOBALVARIABLES.player_creature_count):
		print(%spawnArea.shape.get_size())
		#var top_left = %spawnArea.global_position
		#var bottom_right = %spawnArea.global_position.x - %spawnArea.transform.
		
