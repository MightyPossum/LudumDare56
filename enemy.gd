extends CharacterBody2D

const max_health: int = 100
@export var current_health: int = max_health
@export var attack_speed: float = 1


@export var attack_damage: int = 10
var enemey_queue: Array = []

@export_enum("ally", 'enemy') var attack_target: String

@onready var health_bar: ProgressBar = $health_bar
@onready var attack_timer: Timer = $attack_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.visible = current_health < max_health
	attack_timer.wait_time = attack_speed
	attack_timer.start()
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("ally"):
		enemey_queue.append(area.get_parent())

func _on_attack_timer_timeout() -> void:
	attack()
