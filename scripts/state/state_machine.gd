class_name StateMachine extends Node

@export var INIT_STATE: State
@export var STATE_MACHINE_NAME: String
@onready var current_state: State = INIT_STATE
@export var PLAYER: CharacterBody3D
var state_dictionary: Dictionary = {}

func _ready() -> void:
	var children: Array[Node] = get_children()
	for child in children:
		if child is not State:
			push_warning("Non state node in %s state machine!" % STATE_MACHINE_NAME)
			continue
		
		var child_state: State = child as State
		state_dictionary[child_state.name] = child_state
		child_state.transition.connect(state_transition)
	
	await owner.ready
	Global.debug.append_property("State", current_state.name)


func _process(delta: float) -> void:
	current_state.update_state(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_update_state(delta)


func state_transition(next_state_name: StringName) -> void:
	if not next_state_name:
		push_error("%s state machine attempted to transition to null state!" % STATE_MACHINE_NAME)
	
	if next_state_name == current_state.name: return #nothing to do
	
	if next_state_name not in state_dictionary:
		push_error("State: \"%s\", not found in %s state machine!" % [next_state_name, STATE_MACHINE_NAME])
	
	var previous_state: State = current_state 
	previous_state.exit_state(next_state_name)
	current_state = state_dictionary.get(next_state_name)
	current_state.enter_state(previous_state.STATE_NAME)
	Global.debug.append_property("State", current_state.name)
	
	
	
