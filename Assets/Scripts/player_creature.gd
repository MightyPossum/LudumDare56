extends RigidBody2D

@onready var navgationAgent2D : NavigationAgent2D = get_node("NavigationAgent2D")
@onready var game_manager : Node2D = get_parent().get_parent()

var pathing_initalized : bool = false
var targeted_enemy : bool = false

var speed : int = 100

func _physics_process(delta: float) -> void:
	if navgationAgent2D.is_target_reachable() and int(navgationAgent2D.distance_to_target() > game_manager.distance_to_enemy):
		var next_location = navgationAgent2D.get_next_path_position()
		var direction = global_position.direction_to(next_location)
		global_position += direction * delta * speed
	elif navgationAgent2D.is_target_reachable() and targeted_enemy:
		pathing_initalized = false


	if !pathing_initalized:
		pathing_initalized = true
		navgationAgent2D.set_target_position(game_manager.get_enemy_base_location())


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemy'):
		navgationAgent2D.set_target_position(body.global_position)
		targeted_enemy = true