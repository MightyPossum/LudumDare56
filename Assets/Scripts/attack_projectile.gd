extends Node2D
@export var speed: float = 200.0
var shooter : RigidBody2D
var target: RigidBody2D
var target_position : Vector2
var attack_damage : float = 0
var attack_target
var projectile_sprite
var target_hit = false
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

	await get_tree().create_timer(2, false,true).timeout
	queue_free()

func init(_target : RigidBody2D, _shooter : RigidBody2D, _position : Vector2, _attack_damage : float, _attack_target : String) -> void:
	target = _target
	target_position = target.global_position
	shooter = _shooter
	position = _position
	attack_damage = _attack_damage
	attack_target = _attack_target

func _physics_process(delta: float) -> void:
	move_towards_target(delta)
	if global_position.distance_to(target.global_position) <= 8:
		queue_free()

func move_towards_target(delta: float):
	if position.distance_to(target_position) >= 2:
		var direction = (target_position - position).normalized()
		position += direction * speed * delta
	else:
		if not target.is_alive:
			queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(attack_target) and not target_hit:
		if shooter.is_in_group("enemy"):
			if not shooter.is_boss:
				target_hit = true
		else:
			target_hit = true

		body.call_deferred("take_damage",attack_damage, shooter)
		
		if not target_hit:
			attack_damage = attack_damage/1.25

		queue_free();
	
