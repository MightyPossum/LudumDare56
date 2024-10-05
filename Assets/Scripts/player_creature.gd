extends RigidBody2D

var max_health: int = 100
var enemy_queue: Array = []
var attack_target: String = "enemy"
var current_health: int
var attack_speed: float = 0.2
var attack_damage: int = 10
var movement_speed : int = 100
var shooting_range : int = 40


@onready var health_bar: ProgressBar = $health_bar
@onready var navgationAgent2D : NavigationAgent2D = get_node("NavigationAgent2D")

var pathing_initalized : bool = false
var targeted_enemy : bool = false
var ongoing_wave : bool = false
var in_combat: bool = false
var is_alive: bool = true


var has_been_damaged = false;
var damage_timer = 0.5;
var timer = 0.0;

@export var attack_projectile: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.visible = current_health < max_health
	$Sprite2D/AnimationPlayer.play("Walk")

func _physics_process(delta: float) -> void:
	
	if has_been_damaged:
		$Sprite2D/AnimationPlayer.play("Hurt")
		timer += delta
		if timer >= damage_timer:
			has_been_damaged = false
			timer = 0.0
	else:
		$Sprite2D/AnimationPlayer.play("Walk")
	
	
	if navgationAgent2D.is_target_reachable() and int(navgationAgent2D.distance_to_target() > GLOBALVARIABLES.game_manager.distance_to_enemy):
		var next_location = navgationAgent2D.get_next_path_position()
		var direction = global_position.direction_to(next_location)

		if direction.x < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
			pass
		global_position += direction * delta * movement_speed

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
	enemy_queue.clear()
	is_alive = false
	visible = false
	GLOBALVARIABLES.ally_count -= 1
	

func attack() -> void:
	if enemy_queue.size() > 0:
		var enemy = enemy_queue[0]
		if enemy:
			var bullet = attack_projectile.instantiate()
			bullet.target_position = Vector2(enemy.position.x, enemy.position.y)
			bullet.shooter = "Slime"
			get_parent().add_child(bullet)
			bullet.position = global_position
			bullet.attack_damage = attack_damage
			bullet.attack_target = attack_target
						
			if enemy.has_method("take_damage"):
				var is_enemy_alive = enemy.take_damage(0)
				if not is_enemy_alive:
					enemy_queue.erase(enemy)
		else:
			pass

func take_damage(damage: int) -> bool:
	if is_alive:
		current_health = max(current_health - damage, 0)
		health_bar.value = current_health
		health_bar.visible = current_health < max_health
		has_been_damaged = true
		
	return is_alive

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(attack_target):
		navgationAgent2D.set_target_position(body.global_position)
		targeted_enemy = true
		enemy_queue.append(body)

func set_spawn_position(spawn_position : Vector2) -> void:
	global_position = spawn_position

func initialize_values(initial_values : Dictionary) -> void:
	max_health = initial_values.health
	current_health = max_health
	attack_speed = initial_values.attack_speed/100
	movement_speed = initial_values.movement_speed
	shooting_range = initial_values.range
	attack_damage = initial_values.damage