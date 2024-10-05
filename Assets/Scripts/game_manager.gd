extends Node2D

var ongoing_wave = false

@export var distance_to_enemy = 20
@onready var main_ui : Control = %MainUI

var player_creature

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
	
	player_creature = load("res://Assets/Scenes/player_creature.tscn")

	for i in range(0,GLOBALVARIABLES.player_creature_count):
		var area_middle = %spawnArea.global_position
		var x_position = area_middle.x-%spawnArea.shape.get_size().x/2 + randi_range(1,%spawnArea.shape.get_size().x-1)
		GLOBALVARIABLES.ally_count += 1
		var y_position = area_middle.y-%spawnArea.shape.get_size().y/2 + randi_range(1,%spawnArea.shape.get_size().y-1)
		
		var spawn_vector = Vector2(x_position, y_position)
		var spawn_creature = player_creature.instantiate()
		spawn_creature.set_spawn_position(spawn_vector)
		%Creatures.add_child(spawn_creature)
		await get_tree().create_timer(0.25).timeout
		
func _on_bass_range_body_entered(_body: Node2D) -> void:
	win()
