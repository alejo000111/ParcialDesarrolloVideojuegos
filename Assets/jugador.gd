extends CharacterBody3D

## Velocidad máxima de desplazamiento, en metros por segundo.
@export var speed: float = 4.0
## Agregar salto fuerza jugador  
@export var jump_velocity: float = 4.5
## Aceleración progresiva al moverse (punto 3)
@export var aceleracion: float = 12.0
## Fricción progresiva al frenar (punto 3)
@export var friccion: float = 16.0
## Cámara que define qué es "adelante". Si se deja vacía se usa la activa.
@export var camara: Camera3D


func _ready() -> void:
	if camara == null:
		camara = get_viewport().get_camera_3d()

func _physics_process(delta: float) -> void:
	# --- Horizontal: hacia dónde quiere ir ------------------------------
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var entrada := Vector3(input_dir.x, 0.0, input_dir.y)

	# Movimiento relativo a la cámara (mismo patrón de la Sesión 8/9).
	var direction := camara.global_basis * entrada
	direction.y = 0.0
	direction = direction.normalized()

	# TODO (Tarea 3): esto asigna la velocidad DE GOLPE. Reemplazar por
	# move_toward con aceleración y fricción, como en la Sesión 9.
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, aceleracion * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, aceleracion * delta)
	else:
		velocity.x= move_toward(velocity.x, 0.0, friccion * delta)
		velocity.z = move_toward(velocity.z, 0.0, friccion * delta)

	# TODO (Tarea 2): falta la función de salto completa. Todavía no hay
	# gravedad ni velocity.y en absoluto — por eso caminar funciona bien
	# aunque no exista ningún piso en la escena.
	#Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	#salto
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()
