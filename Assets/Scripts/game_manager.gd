extends Node2D

@export var distance_to_enemy = 20
@onready var main_ui : Control = %MainUI

var next_location : Array

var ongoing_wave : bool = false
var all_spawned :bool  = false

func _ready():
	next_location = [
		get_node("Enemies/Boss1").global_position,
		get_node("Enemies/Boss2").global_position,
		get_node("Enemies/Boss3").global_position,
		get_node("Enemies/Boss4").global_position,
		get_node("EnemyBase").global_position,
	]
	GLOBALVARIABLES.game_manager = self
	if GLOBALVARIABLES.round_counter == 0:
		main_ui.set_upgrade_panel_visibility(false)
		main_ui.set_start_wave_button_visibility(true)
		main_ui.set_stats_visibility(false)
	elif GLOBALVARIABLES.round_counter >= 1:
		
		main_ui.set_upgrade_panel_visibility(true)
		main_ui.set_start_wave_button_visibility(true)
		main_ui.set_stats_visibility(false)
	else:
		main_ui.set_upgrade_panel_visibility(false)
		main_ui.set_start_wave_button_visibility(false)
		main_ui.set_stats_visibility(true)

	%CanvasLayer.visible = true

func _physics_process(_delta: float) -> void:
	if ongoing_wave && all_spawned:
		if GLOBALVARIABLES.ally_count <= 0:
			lose()
	
	if Input.is_action_pressed("cheat"):
		GLOBALVARIABLES.player_resource += 50000
		GLOBALVARIABLES.main_ui.update_upgrade_costs()
	
	if Input.is_action_just_pressed("speed_up"):
		if Engine.time_scale <= 1:
			Engine.time_scale += 1

	if Input.is_action_just_pressed("cheat_speed"):
		Engine.time_scale += 1

	if Input.is_action_just_pressed("speed_down"):
		if Engine.time_scale >= 1:
			Engine.time_scale -= 1

func get_next_location() -> Vector2:
	if not %NavigationRegion2D.is_baking():
		%NavigationRegion2D.bake_navigation_polygon()
	return next_location.front()

func is_location_base(current_next_location_vector : Vector2) -> bool:
	if current_next_location_vector == next_location.back():
		return true
	else:
		return false


func win() -> void:
	await get_tree().create_timer(2, false,true).timeout
	get_tree().quit()
	

func lose() -> void:
	if GLOBALVARIABLES.round_counter == 0:
		GLOBALVARIABLES.creature_defaults.get(GLOBALVARIABLES.CREATURE_TYPES.SLIME)["health"] += 70
		GLOBALVARIABLES.creature_defaults.get(GLOBALVARIABLES.CREATURE_TYPES.SLIME)["damage"] += 5
	GLOBALVARIABLES.round_counter += 1
	get_tree().reload_current_scene()
	
func start_wave() -> void:
	main_ui.set_start_wave_button_visibility(false)
	ongoing_wave = true
	spawn_creatures()

func spawn_creatures() -> void:
	
	var slime_creature : PackedScene = load("res://Assets/Scenes/slime_creature.tscn")
	var imp_creature : PackedScene = load("res://Assets/Scenes/imp_creature.tscn")
	var ghost_creature : PackedScene = load("res://Assets/Scenes/ghost_creature.tscn")

	for creature in GLOBALVARIABLES.creature_defaults:
		var creature_values = GLOBALVARIABLES.creature_defaults.get(creature)
		for i in range(0,creature_values.summon_amount):
			var creature_type : PackedScene
			if creature == GLOBALVARIABLES.CREATURE_TYPES.SLIME:
				creature_type = slime_creature
			elif creature == GLOBALVARIABLES.CREATURE_TYPES.IMP:
				creature_type = imp_creature
			elif creature == GLOBALVARIABLES.CREATURE_TYPES.GHOST:
				creature_type = ghost_creature

			var area_middle = %spawnArea.global_position
			var x_position = area_middle.x-%spawnArea.shape.get_size().x/2 + randi_range(1,%spawnArea.shape.get_size().x-1)
			var y_position = area_middle.y-%spawnArea.shape.get_size().y/2 + randi_range(1,%spawnArea.shape.get_size().y-1)

			GLOBALVARIABLES.ally_count += 1
			
			var spawn_vector = Vector2(x_position, y_position)
			var spawn_creature = creature_type.instantiate()
			spawn_creature.set_spawn_position(spawn_vector)
			spawn_creature.initialize_values(creature_values)
			spawn_creature.creature_type = creature
			%Creatures.add_child(spawn_creature)
			await get_tree().create_timer(.75, false,true).timeout
	
	all_spawned = true

func _on_bass_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("ally"):
		win()
