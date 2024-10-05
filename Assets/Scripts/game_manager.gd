extends Node2D

var ally_count = 0

@export var distance_to_enemy = 20

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
