extends RigidBody2D

@export var max_health : int = 100
@export var kill_value : int = 1000
@export var attack_damage : int = 10
@export var attack_speed_delay : float = 20
@export var shooting_range : int = 50
@export var is_boss : bool = false

@onready var health_bar: ProgressBar = $health_bar

var attack_target: String = "ally"

var current_health : int
var attack_speed : float = 1.0
var enemy_queue: Array = []

var in_combat : bool = false
var is_alive : bool = true 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.visible = current_health < max_health
	$AnimationPlayer.play("Idle")
	attack_speed = attack_speed_delay/100.0

func _physics_process(delta: float) -> void:
	if is_alive:	
		if current_health <= 0:
			await get_tree().create_timer(.5).timeout
			die()
		
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
				attack()
				await get_tree().create_timer(attack_speed).timeout
				in_combat = false

func die() -> void:
	enemy_queue.clear()
	GLOBALVARIABLES.player_resource += kill_value
	is_alive = false
	visible = false
	
func attack() -> void:
	if enemy_queue.size() > 0:
		var enemy = enemy_queue[0]
		if enemy:
			var bullet = attack_projectile.instantiate()
			bullet.target_position = Vector2(enemy.position.x, enemy.position.y)
			bullet.shooter = "Enemy"
			get_parent().add_child(bullet)
			bullet.position = global_position
			bullet.attack_damage = attack_damage
			bullet.attack_target = attack_target
			
			if enemy.has_method("take_damage"):
				var is_enemy_alive = enemy.take_damage(0)
				if not is_enemy_alive:
					enemy_queue.erase(enemy)

func take_damage(damage: int) -> bool:
	if is_alive:
		current_health = max(current_health - damage, 0)
		health_bar.value = current_health
		health_bar.visible = current_health < max_health
		
	return is_alive

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(attack_target):
		enemy_queue.append(body)
