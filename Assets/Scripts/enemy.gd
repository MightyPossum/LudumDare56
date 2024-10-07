extends RigidBody2D

@export var max_health : int = 100
@export var kill_value : int = 1000
@export var attack_damage : int = 10
@export var attack_speed_delay : float = 0.7
@export var shooting_range : int = 100
@export var movement_speed : float = 100
@export var detection_range : int = 100
@export var is_boss : bool = false
@export var sprite : CompressedTexture2D
@export var attack_projectile : PackedScene

@onready var health_bar: ProgressBar = $health_bar
@onready var navgationAgent2D : NavigationAgent2D = get_node("NavigationAgent2D")

var hurt_timer : float = 0.5
var hurting : bool = false
var attack_target : String = "ally"
var current_health : int
var attack_speed : float = 1.0
var enemy_queue	: Array = []
var start_position : Vector2
var enemy_in_view : bool = false
var creature_type : int = 4

var in_combat : bool = false
var is_alive : bool = true 
var pathing_initalized : bool = false
var has_been_damaged = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.visible = current_health < max_health
	$AnimationPlayer.play("Idle")
	attack_speed = attack_speed_delay

	%AreaShape.shape.set_radius(detection_range)

	%EnemyArt.texture = sprite

func _physics_process(delta: float) -> void:
	if is_alive:	
		if has_been_damaged:
			if not hurting:
				$AnimationPlayer.play("Hurt")
				hurting = true
				await get_tree().create_timer(hurt_timer, false,true).timeout
				hurting = false
				has_been_damaged = false
		elif not hurting:
			$AnimationPlayer.play("Idle")
	if enemy_queue.size() > 0 and not in_combat:
		in_combat = true
		var enemy = enemy_in_range()
		if enemy:
			attack(enemy)
			enemy_in_view = true
			await get_tree().create_timer(attack_speed, false,true).timeout
		else:
			enemy_in_view = false
			await get_tree().create_timer(attack_speed/2, false,true).timeout
		in_combat = false
	
	if not is_boss and enemy_queue.size() > 0 and navgationAgent2D.is_target_reachable() and (int(navgationAgent2D.distance_to_target() > shooting_range) or not enemy_in_view):
		var next_location = navgationAgent2D.get_next_path_position()
		var direction = global_position.direction_to(next_location)

		if direction.x < 0:
			$EnemyArt.flip_h = false
		else:
			$EnemyArt.flip_h = true

		global_position += direction * delta * movement_speed
		navgationAgent2D.set_target_position(enemy_queue[0].global_position)

	elif enemy_queue.size() <= 0 and pathing_initalized:
		pathing_initalized = false

	if !pathing_initalized:
		if enemy_queue.size() > 0:
			pathing_initalized = true
			navgationAgent2D.set_target_position(enemy_queue[0].global_position)



func enemy_in_range() -> RigidBody2D:
	for enemy in enemy_queue:
		if not enemy.is_alive:
			enemy_queue.erase(enemy)
		if global_position.distance_to(enemy.global_position) < shooting_range:
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(global_position, enemy.global_position, collision_mask, [self])
			var result = space_state.intersect_ray(query)
			if result:
				if result.get("collider").is_in_group(attack_target):
					return enemy
	return null

func die() -> void:
	match name:
		"Boss1":
			GLOBALVARIABLES.game_manager.next_location.pop_front()
			GLOBALVARIABLES.bosses_left -= 1
			%WallBreak.play()
			%Wall1.queue_free()
		"Boss2":
			GLOBALVARIABLES.game_manager.next_location.pop_front()
			GLOBALVARIABLES.bosses_left -= 1
			%WallBreak.play()
			%Wall2.queue_free()
		"Boss3":
			GLOBALVARIABLES.game_manager.next_location.pop_front()
			GLOBALVARIABLES.bosses_left -= 1
			%WallBreak.play()
			%Wall3.queue_free()
		"Boss4":
			GLOBALVARIABLES.game_manager.next_location.pop_front()
			GLOBALVARIABLES.bosses_left -= 1
			%WallBreak.play()
			%Wall4.queue_free()

	enemy_queue.clear()
	GLOBALVARIABLES.player_resource += kill_value
	is_alive = false
	visible = false
	EVENTS.trigger_path_calc.emit()

	%Area.monitoring = false
	%Area.monitorable = false
	%Collider.disabled = true
	
func attack(enemy : RigidBody2D) -> void:
	if enemy:
		var bullet = attack_projectile.instantiate()
		bullet.init(enemy, self, global_position,attack_damage,attack_target)
		%AttackSound.play()

		get_parent().add_child(bullet)

func take_damage(damage: int, damager : RigidBody2D) -> void:
	if is_alive:
		if is_boss:
			GLOBALVARIABLES.player_resource += int(kill_value/5000*damage)
		if enemy_queue.size() <= 0:
			enemy_queue.append(damager)
		current_health = max(current_health - damage, 0)
		health_bar.value = current_health
		health_bar.visible = current_health < max_health
		has_been_damaged = true
		
		if current_health <= 0:
			die()

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group(attack_target):
		if not enemy_queue.has(body):
			enemy_queue.append(body)
