extends RigidBody2D

const max_health: int = 100
@export var current_health: int = max_health
@export var attack_speed: float = 1.0
var in_combat: bool = false

@export var attack_damage: int = 10
var enemey_queue: Array = []

@export_enum("ally", 'enemy') var attack_target: String

@onready var health_bar: ProgressBar = $health_bar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.visible = current_health < max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if enemey_queue.size() > 0 and not in_combat:
		in_combat = true
		attack()
		await get_tree().create_timer(attack_speed).timeout
		in_combat = false
	
	if current_health <= 0:
		die()

func die() -> void:
	#TODO: Give money to player
	#TODO: Play death animation
	queue_free()
	

func attack() -> void:
	if enemey_queue.size() > 0:
		var enemy = enemey_queue[0]
		if enemy.has_method("take_damage"):
			enemy.take_damage(attack_damage)
			if enemy.current_health <= 0:
				enemey_queue.remove_at(0)

func take_damage(damage: int) -> void:
	current_health = max(current_health - damage, 0)
	health_bar.value = current_health
	health_bar.visible = current_health < max_health

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent().is_in_group(attack_target):
		enemey_queue.append(body.get_parent())
