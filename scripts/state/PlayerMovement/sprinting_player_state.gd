class_name SprintingPlayerState extends PlayerMovementState


func enter_state(_previous_state: StringName) -> void:
	Global.debug_print("Entering Sprinting State")


func exit_state(_next_state: StringName) -> void:
	Global.debug_print("Exiting Sprinting State")


func handle_input() -> void:
	pass


func update_state(_delta: float) -> void:
	pass


func physics_update_state(delta: float) -> void:
	PLAYER.handle_movement_input(PLAYER.SPRINT_SPEED, PLAYER.SPRINT_ACCELERATION)
	PLAYER.update_movement(delta)
	
	if not PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
	elif Input.is_action_just_pressed("jump"):
		transition.emit("JumpingPlayerState")
	elif PLAYER.velocity.length() <= 0.0:
		transition.emit("IdlingPlayerState")
	elif Input.is_action_just_released("sprint"):
		transition.emit("WalkingPlayerState")
	elif PLAYER.velocity.length() > 0.0:
		pass #stay in walking
	else:
		push_error("unaccounted for case for player walking state")
	
	
