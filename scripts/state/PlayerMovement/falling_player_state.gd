class_name FallingPlayerState extends PlayerMovementState

func enter_state(_previous_state: StringName) -> void:
	Global.debug_print("Entering Falling State")


func exit_state(_next_state: StringName) -> void:
	Global.debug_print("Exiting Falling State")


func update_state(_delta: float) -> void:
	pass


func physics_update_state(delta: float) -> void:
	PLAYER.handle_movement_input()
	PLAYER.update_movement(delta)
	
	if PLAYER.is_on_floor() and PLAYER.velocity.length() <= 0.0:
		transition.emit("IdlingPlayerState")
	elif PLAYER.is_on_floor() and PLAYER.velocity.length() > 0.0:
		transition.emit("WalkingPlayerState")
	elif not PLAYER.is_on_floor():
		pass # stay in falling state
	else:
		push_error("unaccounted for case for player falling state")
