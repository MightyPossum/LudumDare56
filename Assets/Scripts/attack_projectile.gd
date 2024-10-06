extends Node2D
@export var speed: float = 200.0
var shooter = "Someone"
var target_position: Vector2
var attack_damage = 0
var attack_target
var projectile_sprite
@onready var sprite = $Sprite

func _ready():
	print(shooter)
	match shooter:
		"Slime":
			sprite.texture = preload("res://Assets/Sprites/Slime.png")
		"Imp":
			sprite.texture = preload("res://Assets/Sprites/Imp.png")
		"Ghost":
			sprite.texture = preload("res://Assets/Sprites/Ghost.png")
		"Enemy":
			sprite.texture = preload("res://Assets/Sprites/Enemy1.png")

func _process(delta: float):
	if position.distance_to(target_position) > 1.0:
		move_towards_target(delta)

func move_towards_target(delta: float):
	var direction = (target_position - position).normalized()
	position += direction * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(attack_target):					
		if body.has_method("take_damage"):
			body.take_damage(attack_damage)
				
				
		queue_free();
	
