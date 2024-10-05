extends Camera2D

# Variables to store the state of the middle mouse button and the previous mouse position
var is_panning = false
var prev_mouse_pos = Vector2()

# Sensitivity for panning speed
var zoom_speed = 0.1
var pan_speed = 1.0

func _ready():
	zoom = Vector2(2,2)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				# Start panning when the middle mouse button is pressed
				is_panning = true
				prev_mouse_pos = event.position
			else:
				# Stop panning when the middle mouse button is released
				is_panning = false
				
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoom_speed,zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoom_speed,zoom_speed)
	
	if event is InputEventMouseMotion and is_panning:
		# Calculate the mouse movement delta and update the camera position
		var mouse_delta = event.position - prev_mouse_pos
		global_position -= mouse_delta * pan_speed / zoom
		
		# Update the previous mouse position
		prev_mouse_pos = event.position
