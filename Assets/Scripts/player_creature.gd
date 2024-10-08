extends RigidBody2D

var max_health: int = 100
var enemy_queue: Array = []
var attack_target: String = "enemy"
var current_health: int
var attack_speed: float = 0.2
var attack_damage: float = 10
var movement_speed : float = 100
var shooting_range : int = 40

var exlusion_list : Array = [self]

var creature_type : int = 0

@onready var health_bar: ProgressBar = $health_bar
@onready var navgationAgent2D : NavigationAgent2D = get_node("NavigationAgent2D")

var pathing_initalized : bool = false
var is_location_the_base : bool = false
var targeted_enemy : bool = false
var ongoing_wave : bool = false
var in_combat : bool = false
var is_alive : bool = true
var enemy_in_view : bool = false

var has_been_damaged = false;
var damage_timer = 0.5;
var timer = 0.0;

var has_boost : bool = false
var has_shield : bool = false

var in_hole : bool = false

@export var attack_projectile: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.visible = current_health < max_health
	EVENTS.boost_activated.connect(handle_boost_activation)
	EVENTS.shield_activated.connect(handle_shield_activation)
	EVENTS.trigger_path_calc.connect(calc_path)

	$Sprite2D/AnimationPlayer.play("Walk")
	

func _physics_process(delta: float) -> void:
	
	if in_hole:
		scale -= Vector2(0.2, 0.2)
		if scale < (Vector2(0,0)):
			queue_free()
	
	if is_alive:
		if has_been_damaged:
			$Sprite2D/AnimationPlayer.play("Hurt")
			timer += delta
			if timer >= damage_timer:
				has_been_damaged = false
				timer = 0.0
		else:
			
			var walk_animation : String

			if has_boost:
				walk_animation = "Walk_power"
			elif has_shield:
				walk_animation = "Walk_shield"
			else:
				walk_animation = "Walk"

			$Sprite2D/AnimationPlayer.play(walk_animation)

		if enemy_queue.size() == 0 and targeted_enemy:
			targeted_enemy = false
		
		if navgationAgent2D.is_target_reachable() and ((int(navgationAgent2D.distance_to_target() >= shooting_range) or targeted_enemy) or (is_location_the_base and int(navgationAgent2D.distance_to_target() > 2))):

			if targeted_enemy and enemy_in_view:
				pass
			else:

				var next_location = navgationAgent2D.get_next_path_position()
				var direction = global_position.direction_to(next_location)

				if direction.x < 0:
					$Sprite2D.flip_h = true
				else:
					$Sprite2D.flip_h = false
					pass
				global_position += direction * delta * movement_speed

		elif navgationAgent2D.is_target_reachable() and enemy_queue.size() == 0:
			targeted_enemy = false
			pathing_initalized = false

		if !pathing_initalized:
			pathing_initalized = true
			calc_path()

		if enemy_queue.size() > 0 and not in_combat:
			calc_path()
			in_combat = true
			var enemy = enemy_in_range()
			if enemy:
				attack(enemy)
				enemy_in_view = true
				await get_tree().create_timer(attack_speed, false,true).timeout
			else:
				enemy_in_view = false
			
			in_combat = false

func enemy_in_range() -> RigidBody2D:
	for enemy in enemy_queue:
		if not enemy.is_alive:
			enemy_queue.erase(enemy)
		if global_position.distance_to(enemy.global_position) < shooting_range:
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(global_position, enemy.global_position, collision_mask, exlusion_list)
			var result = space_state.intersect_ray(query)
			if result.get("collider"):
				if result.get("collider").is_in_group('ally'):
					exlusion_list.append(result.collider)
			if result.get("collider"):
				if result.get("collider").is_in_group(attack_target):
					return enemy

	return null

func die() -> void:
	enemy_queue.clear()
	is_alive = false
	visible = false
	GLOBALVARIABLES.ally_count -= 1

	%Area.monitoring = false
	%Area.monitorable = false
	%Collider.disabled = true

func attack(enemy : RigidBody2D) -> void:
	var bullet = attack_projectile.instantiate()
	bullet.init(enemy, self, global_position,attack_damage,attack_target)
	%CreatureAttack.play()
	get_parent().add_child(bullet)
	
	
func take_damage(damage: int, _damager : RigidBody2D) -> void:
	if is_alive and not has_shield:
		current_health = max(current_health - damage, 0)
		health_bar.value = current_health
		health_bar.visible = current_health < max_health
		has_been_damaged = true
		if current_health <= 0:
			die()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(attack_target):
		if body.is_alive:
			navgationAgent2D.set_target_position(body.global_position)
			targeted_enemy = true
			enemy_queue.append(body)

func set_spawn_position(spawn_position : Vector2) -> void:
	global_position = spawn_position

func initialize_values(initial_values : Dictionary) -> void:
	max_health = initial_values.health
	current_health = max_health
	attack_speed = initial_values.attack_speed
	movement_speed = initial_values.movement_speed
	shooting_range = initial_values.attack_range
	attack_damage = initial_values.damage

func handle_boost_activation(boost_time : float) -> void:
	has_boost = true
	
	var boost_power_factor = GLOBALVARIABLES.boost_power_factor
	
	attack_damage = attack_damage*boost_power_factor
	movement_speed = movement_speed*boost_power_factor
	attack_speed = attack_speed/boost_power_factor

	await get_tree().create_timer(boost_time, false,true).timeout
	
	has_boost = false

	attack_damage = attack_damage/boost_power_factor
	movement_speed = movement_speed/boost_power_factor
	attack_speed = attack_speed*boost_power_factor

func handle_shield_activation(shield_time : float) -> void:
	has_shield = true
	await get_tree().create_timer(shield_time, false,true).timeout
	has_shield = false

func calc_path():
	if enemy_queue.size() <= 0:
		var next_location : Vector2
		next_location = GLOBALVARIABLES.game_manager.get_next_location()
		navgationAgent2D.set_target_position(next_location)
		is_location_the_base = GLOBALVARIABLES.game_manager.is_location_base(next_location)
	else:
		navgationAgent2D.set_target_position(enemy_queue[0].global_position)
		
