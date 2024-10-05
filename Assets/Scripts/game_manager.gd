extends Node2D

@export var distance_to_enemy = 20

func get_enemy_base_location() -> Vector2:
	return get_node("EnemyBase").global_position
