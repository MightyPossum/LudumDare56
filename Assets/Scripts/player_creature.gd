extends RigidBody2D

var max_health: int = GLOBALVARIABLES.player_creature_max_health
@export var current_health: int = max_health
@export var attack_speed: float = .2
var in_combat: bool = false
var is_alive: bool = true

@export var attack_damage: int = 10
var enemy_queue: Array = []

var attack_target: String = "enemy"

@onready var health_bar: ProgressBar = $health_bar
@onready var navgationAgent2D : NavigationAgent2D = get_node("NavigationAgent2D")
# var game_manager : Node2D = GLOBALVARIABLES.game_manager

var pathing_initalized : bool = false
var targeted_enemy : bool = false
var ongoing_wave : bool = false

var movment_speed : int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.visible = current_health < max_health
	$Sprite2D/AnimationPlayer.play("Walk")

func _physics_process(delta: float) -> void:
	if navgationAgent2D.is_target_reachable() and int(navgationAgent2D.distance_to_target() > GLOBALVARIABLES.game_manager.distance_to_enemy):
		var next_location = navgationAgent2D.get_next_path_position()
		var direction = global_position.direction_to(next_location)
		global_position += direction * delta * movment_speed
	elif navgationAgent2D.is_target_reachable() and enemy_queue.size() == 0:
		pathing_initalized = false

	if !pathing_initalized:
		pathing_initalized = true
		navgationAgent2D.set_target_position(GLOBALVARIABLES.game_manager.get_enemy_base_location())

	if enemy_queue.size() > 0 and not in_combat:
		in_combat = true
		attack()
		await get_tree().create_timer(attack_speed).timeout
		in_combat = false
	
	if current_health <= 0:
		await get_tree().create_timer(.5).timeout
		die()

func die() -> void:
	#TODO: Give money to player
	#TODO: Play death animation
	enemy_queue.clear()
	is_alive = false
	visible = false
	GLOBALVARIABLES.ally_count -= 1
	

func attack() -> void:
	if enemy_queue.size() > 0:
		var enemy = enemy_queue[0]
		if enemy:
			if enemy.has_method("take_damage"):
				var is_enemy_alive = enemy.take_damage(attack_damage)
				if not is_enemy_alive:
					enemy_queue.erase(enemy)
		else:
			pass

func take_damage(damage: int) -> bool:
	if is_alive:
		current_health = max(current_health - damage, 0)
		health_bar.value = current_health
		health_bar.visible = current_health < max_health
		
	return is_alive

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(attack_target):
		navgationAgent2D.set_target_position(body.global_position)
		targeted_enemy = true
		enemy_queue.append(body)

func set_spawn_position(spawn_position : Vector2) -> void:
	global_position = spawn_position