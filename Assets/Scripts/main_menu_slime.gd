extends Sprite2D
var dirRight = true
var speed = 0.7

func _ready() -> void:
	flip_h = false
	$AnimationPlayer.play("Walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	
	if dirRight and position.x > get_viewport().get_visible_rect().size.x + 64:
		dirRight = false
		speed = -speed
		flip_h = true
	
	if not dirRight and position.x < get_viewport().get_visible_rect().position.x - 64:
		dirRight = true
		speed = -speed
		flip_h = false
	
	position.x += speed	
