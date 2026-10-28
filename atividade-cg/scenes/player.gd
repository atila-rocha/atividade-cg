extends CharacterBody3D

@export var SPEED: float = 7.0
@export var JUMP_VELOCITY: float = 8.5
@export var ACCELERATION: float = 25.0
@export var DECELERATION: float = 30.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm: SpringArm3D = $SpringArm3D

func _physics_process(delta: float) -> void:
	# 1. Aplicação da gravidade
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Leitura do direcional
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 4. Cálculo da direção baseado Apenas na rotação Y (Yaw) da câmera
	# Isso evita que olhar para baixo/cima afete a velocidade de caminhada
	var camera_rotation_y: float = spring_arm.global_transform.basis.get_euler().y
	var forward := Vector3.FORWARD.rotated(Vector3.UP, camera_rotation_y)
	var right := Vector3.RIGHT.rotated(Vector3.UP, camera_rotation_y)
	
	# Vetor final no plano horizontal (XZ)
	var direction := (right * input_dir.x + forward * input_dir.y).normalized()

	# 5. Movimentação suave (Aceleração e Desaceleração)
	if direction != Vector3.ZERO:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
		
		# Suaviza a rotação do cubo na direção do movimento
		var target_angle := atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, delta * 12.0)
	else:
		velocity.x = move_toward(velocity.x, 0.0, DECELERATION * delta)
		velocity.z = move_toward(velocity.z, 0.0, DECELERATION * delta)

	# 6. Aplicação da física
	move_and_slide()
