extends Node2D

var ally_count = 0

@export var distance_to_enemy = 20
@onready var main_ui : Control = %MainUI

func _ready():
	GLOBALVARIABLES.game_manager = self

func _ready() -> void:
	ally_count = get_node("Creatures:").get_child_count()

func _process(_delta):
	if ally_count <= 0:
		lose()

func get_enemy_base_location() -> Vector2:
	return get_node("EnemyBase").global_position

func win() -> void:
	print("You win!")
	get_tree().reload_current_scene()

func lose() -> void:
	print("You lose!")
	get_tree().quit()
func start_wave() -> void:
	main_ui.set_start_wave_button_visibility(false)
	spawn_creatures()

func spawn_creatures() -> void:
	for i in range(0,GLOBALVARIABLES.player_creature_count):
		print(%spawnArea.shape.get_size())
		#var top_left = %spawnArea.global_position
		#var bottom_right = %spawnArea.global_position.x - %spawnArea.transform.
		
