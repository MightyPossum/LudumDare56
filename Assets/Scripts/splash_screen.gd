extends Control

@export var delay : float
var main_menu_scene: PackedScene = preload("res://Assets/Scenes/main_menu.tscn")
var timer : float = 0.0
var screen : int = 0

var load_time : int

func _ready():
	# Initialize the splash screen visibility
	$Splash1.visible = true
	$Splash2.visible = false

func _process(delta):
	timer += delta
	if timer >= delay:
		next_step()

func _input(event):
	if event is InputEventKey and event.pressed:
		next_step()
	if event is InputEventMouseButton and event.pressed:
		next_step()

# Advande to the next step i.e change screen or load menu
func next_step():
	if screen < 2:
		screen += 1
	
	timer = 0.0

	match screen:
		0:
			$Splash1.visible = true
			$Splash2.visible = false
		1:
			$Splash1.visible = false
			$Splash2.visible = true
		2:
			change_to_main_menu()

# Change to the main menu scene
func change_to_main_menu():
		var new_scene = main_menu_scene.instantiate()
		get_tree().root.add_child(new_scene)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = new_scene
