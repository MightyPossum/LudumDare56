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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.visible = current_health < max_health

func _physics_process(_delta: float) -> void:
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
	if body.get_parent().is_in_group(attack_target):
		enemy_queue.append(body.get_parent())
