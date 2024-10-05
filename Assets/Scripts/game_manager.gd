extends Node2D

@export var distance_to_enemy = 20
@onready var main_ui : Control = %MainUI

var player_creature

func _ready():
	GLOBALVARIABLES.game_manager = self

func get_enemy_base_location() -> Vector2:
	return get_node("EnemyBase").global_position

func start_wave() -> void:
	#main_ui.set_start_wave_button_visibility(false)
	spawn_creatures()

func spawn_creatures() -> void:
	
	player_creature = load("res://Assets/Scenes/player_creature.tscn")

	for i in range(0,GLOBALVARIABLES.player_creature_count):
		var area_middle = %spawnArea.global_position
		var x_position = area_middle.x-%spawnArea.shape.get_size().x/2 + randi_range(1,%spawnArea.shape.get_size().x-1)
		var y_position = area_middle.y-%spawnArea.shape.get_size().y/2 + randi_range(1,%spawnArea.shape.get_size().y-1)
		
		var spawn_vector = Vector2(x_position, y_position)
		var spawn_creature = player_creature.instantiate()
		spawn_creature.set_spawn_position(spawn_vector)
		%Creatures.add_child(spawn_creature)
		await get_tree().create_timer(0.25).timeout
