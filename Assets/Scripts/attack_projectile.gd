extends Node2D
@export var speed: float = 200.0
var shooter : RigidBody2D
var target: RigidBody2D
var target_position : Vector2
var attack_damage = 0
var attack_target
var projectile_sprite
@onready var sprite = $Sprite

func _ready():
	match shooter.creature_type:
		0:
			sprite.texture = preload("res://Assets/Sprites/Slime.png")
		1:
			sprite.texture = preload("res://Assets/Sprites/Imp.png")
		2:
			sprite.texture = preload("res://Assets/Sprites/Ghost.png")
		4:
			sprite.texture = preload("res://Assets/Sprites/Enemy1.png")

	await get_tree().create_timer(2).timeout
	queue_free()

func init(_target : RigidBody2D, _shooter : RigidBody2D, _position : Vector2, _attack_damage : int, _attack_target : String) -> void:
	target = _target
	target_position = target.global_position
	shooter = _shooter
	position = _position
	attack_damage = _attack_damage
	attack_target = _attack_target

func _process(delta: float):
	move_towards_target(delta)
	if global_position == target.global_position:
		queue_free()

func move_towards_target(delta: float):
	if position.distance_to(target_position) >= 2:
		var direction = (target_position - position).normalized()
		position += direction * speed * delta
	else:
		if not target.is_alive:
			queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(attack_target):
		body.call_deferred("take_damage",attack_damage, shooter)
		queue_free();
	
