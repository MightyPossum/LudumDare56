extends RigidBody2D

@export var max_health : int = 100
@export var kill_value : int = 1000
@export var attack_damage : int = 10
@export var attack_speed_delay : float = 0.2
@export var shooting_range : int = 100
@export var movement_speed : float = 100
@export var is_boss : bool = false
@export var sprite : CompressedTexture2D
@export var attack_projectile: PackedScene

@onready var health_bar: ProgressBar = $health_bar
@onready var navgationAgent2D : NavigationAgent2D = get_node("NavigationAgent2D")

var damage_timer : float = 0.5;
var timer : float = 0.0;
var attack_target : String = "ally"
var current_health : int
var attack_speed : float = 1.0
var enemy_queue	: Array = []
var start_position : Vector2

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

	%EnemyArt.texture = sprite

func _physics_process(delta: float) -> void:
	if is_alive:	
		if has_been_damaged:
			$AnimationPlayer.play("Hurt")
			timer += delta
			if timer >= damage_timer:
				has_been_damaged = false
				timer = 0.0
			else:
				$AnimationPlayer.play("Idle")
	if enemy_queue.size() > 0 and not in_combat:
		in_combat = true
		var enemy = enemy_in_range()
		if enemy:
			attack(enemy)
			await get_tree().create_timer(attack_speed).timeout
		else:
			await get_tree().create_timer(attack_speed/2).timeout
		in_combat = false
		if navgationAgent2D.is_target_reachable() and int(navgationAgent2D.distance_to_target() > shooting_range):
			var next_location = navgationAgent2D.get_next_path_position()
			var direction = global_position.direction_to(next_location)

			if direction.x < 0:
				$EnemyArt.flip_h = true
			else:
				$EnemyArt.flip_h = false
				pass
			global_position += direction * delta * movement_speed

		elif enemy_queue.size() <= 0 and pathing_initalized:
			pathing_initalized = false

		if !pathing_initalized:
			if enemy_queue.size() > 0:
				pathing_initalized = true
				navgationAgent2D.set_target_position(enemy_queue[0].global_position)
			else:
				navgationAgent2D.set_target_position(start_position)



func enemy_in_range() -> RigidBody2D:
	for enemy in enemy_queue:
		if not enemy.is_alive:
			enemy_queue.erase(enemy)
		if global_position.distance_to(enemy.global_position) < shooting_range:
			return enemy
	return null

func die() -> void:
	match name:
		"Boss1":
			GLOBALVARIABLES.game_manager.next_location.pop_front()
			%Wall1.queue_free()
		"Boss2":
			GLOBALVARIABLES.game_manager.next_location.pop_front()
			%Wall2.queue_free()
		"Boss3":
			GLOBALVARIABLES.game_manager.next_location.pop_front()
			%Wall3.queue_free()
		"Boss4":
			GLOBALVARIABLES.game_manager.next_location.pop_front()
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
		
		bullet.init(enemy, "enemy", global_position,attack_damage,attack_target)
		%AttackSound.play()

		get_parent().add_child(bullet)
		
		if enemy.has_method("take_damage"):
			var is_enemy_alive = enemy.take_damage(0)
			if not is_enemy_alive:
				enemy_queue.erase(enemy)

func take_damage(damage: int) -> bool:
	if is_alive:
		current_health = max(current_health - damage, 0)
		health_bar.value = current_health
		health_bar.visible = current_health < max_health
		has_been_damaged = true
		
		if current_health <= 0:
			die()
		
	return is_alive

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(attack_target):
		enemy_queue.append(body)
