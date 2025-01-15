class_name Player extends CharacterBody3D


@export_category("Movement Settings")
@export var WALK_SPEED: float = 7.0
@export var SPRINT_SPEED_MULTIPLIER: float = 1.33
@export var GRAVITY: Vector3 = Vector3.DOWN * 12
@export var ACCELERATION: float = 1

@export_category("Camera Settings")
@export var CAMERA_TILT_LIMIT: float = deg_to_rad(88)
@export var CAMERA_SENSITIVITY: float = 0.005
@export var MAX_CAMERA_Z_ROLL: float = deg_to_rad(3)
@export var MAX_CAMERA_X_ROLL: float = deg_to_rad(3)
@export var CAMERA_X_ROLL_ACCELERATION: float = .1
@export var CAMERA_Z_ROLL_ACCELERATION: float = .3

@export_category("Nodes")
@export var HEAD: Node3D
@export var CAMERA: Camera3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func update_camera(mouse_input_x: float, mouse_input_y: float) -> void:
	#left/right rotation
	self.rotate_y(-mouse_input_x * CAMERA_SENSITIVITY)
	
	#up/down rotation
	HEAD.rotate_x(-mouse_input_y * CAMERA_SENSITIVITY)
	HEAD.rotation.x = clamp(HEAD.rotation.x, -CAMERA_TILT_LIMIT, CAMERA_TILT_LIMIT)


func _unhandled_input(event: InputEvent) -> void:
	pass


func _physics_process(delta: float) -> void:
	Global.debug.append_property("Velocity", velocity)
	#Global.debug.append_property("FPS", 1 / delta)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("enter"):
		Global.debug_print("")
	if Input.is_action_just_pressed("cursor_toggle"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		update_camera(event.relative.x, event.relative.y)

func handle_movement_input() -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	Global.debug.append_property("Basis", basis)
	Global.debug.append_property("basis x", basis.x)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * WALK_SPEED, ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * WALK_SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		velocity.z = move_toward(velocity.z, 0, WALK_SPEED)
	
	var speed_right = velocity.dot(basis.x)
	var speed_forward = velocity.dot(basis.z)
	var z_roll = remap(-speed_right, -WALK_SPEED, WALK_SPEED, -MAX_CAMERA_Z_ROLL, MAX_CAMERA_Z_ROLL)
	var x_roll = remap(speed_forward, -WALK_SPEED, WALK_SPEED, -MAX_CAMERA_X_ROLL, MAX_CAMERA_X_ROLL)
	CAMERA.rotation.z = lerp(CAMERA.rotation.z, z_roll, CAMERA_Z_ROLL_ACCELERATION)
	CAMERA.rotation.x = lerp(CAMERA.rotation.x, x_roll, CAMERA_X_ROLL_ACCELERATION)


func update_movement(delta) -> void:
	if not is_on_floor():
		velocity += GRAVITY * delta
	move_and_slide()
