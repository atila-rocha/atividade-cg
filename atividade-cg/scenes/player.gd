extends CharacterBody3D

@export var SPEED: float = 7.0
@export var JUMP_VELOCITY: float = 8.5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm: SpringArm3D = $SpringArm3D

func _physics_process(delta: float) -> void:
	# Aplicação da gravidade
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Leitura dos eixos de movimento
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Direção de movimento calculada a partir da orientação visual do SpringArm
	var arm_basis := spring_arm.global_transform.basis
	var direction := (arm_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# Suaviza a rotação do cubo na direção da caminhada
		var target_angle := atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, delta * 10.0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Movimento com inércia física (suporta transporte sobre plataformas móveis)
	move_and_slide()
