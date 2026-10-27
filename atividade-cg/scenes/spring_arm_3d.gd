extends SpringArm3D

@export var mouse_sensibility: float = 0.005

# Limite inferior (olhar para cima/chão): valor negativo (ex: -90 graus)
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var min_vertical_angle: float = -PI/2

# Limite superior (olhar para baixo/teto): valor POSITIVO (ex: +45 graus)
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var MAX_vertical_angle: float = PI/4

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Rotação Horizontal (YAW)
		rotation.y -= event.relative.x * mouse_sensibility
		rotation.y = wrapf(rotation.y, 0.0, TAU)
		
		# Rotação Vertical (PITCH)
		rotation.x -= event.relative.y * mouse_sensibility
		rotation.x = clamp(rotation.x, min_vertical_angle, MAX_vertical_angle)
