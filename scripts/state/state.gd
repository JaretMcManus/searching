class_name State extends Node

@onready var STATE_NAME: StringName = name

@warning_ignore("unused_signal")
signal transition(new_state_name: StringName)


func enter_state(_previous_state: StringName) -> void:
	pass


func exit_state(_next_state: StringName) -> void:
	pass


func handle_input() -> void:
	pass


func update_state(_delta: float) -> void:
	pass


func physics_update_state(_delta: float) -> void:
	pass
