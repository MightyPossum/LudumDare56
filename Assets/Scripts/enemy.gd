extends RigidBody2D

const max_health: int = 100
@export var current_health: int = max_health
@export var attack_speed: float = 1.0
var in_combat: bool = false
var is_alive: = true 

@export var attack_damage: int = 10
var enemy_queue: Array = []

var attack_target: String = "ally"

@onready var health_bar: ProgressBar = $health_bar
var has_been_damaged = false;
var damage_timer = 0.5;
var timer = 0.0;

@export var attack_projectile: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.visible = current_health < max_health
	$AnimationPlayer.play("Idle")

func _physics_process(delta: float) -> void:
	
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
	
	if current_health <= 0:
		await get_tree().create_timer(.5).timeout
		die()


func die() -> void:
	#TODO: Give money to player
	#TODO: Play death animation
	enemy_queue.clear()
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
		#navgationAgent2D.set_target_position(body.global_position)
		#targeted_enemy = true
		enemy_queue.append(body)
