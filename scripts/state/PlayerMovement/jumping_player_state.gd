class_name JumpingPlayerState extends PlayerMovementState

@export var JUMP_VEL: float = 5

func enter_state(_previous_state: StringName) -> void:
	Global.debug_print("Entering Jumping State")
	PLAYER.velocity.y += JUMP_VEL


func exit_state(_next_state: StringName) -> void:
	Global.debug_print("Exiting Jumping State")


func update_state(_delta: float) -> void:
	pass


func physics_update_state(delta: float) -> void:
	PLAYER.handle_movement_input()
	PLAYER.update_movement(delta)
	
	var velocity_length = PLAYER.velocity.length()
	if PLAYER.velocity.y <= 0.0 and not PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
	elif velocity_length <= 0.0 and PLAYER.is_on_floor():
		transition.emit("IdlingPlayerState")
	elif velocity_length > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")
	elif PLAYER.velocity.y > 0.0 and velocity_length > 0.0:
		pass # stay in jump state
	else:
		push_error("unaccounted for state case for Jumping")
