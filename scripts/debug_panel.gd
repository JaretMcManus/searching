extends PanelContainer


@export var VBOX: VBoxContainer


func _ready() -> void:
	Global.debug = self


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"):
		visible = !visible


func append_property(title: String, value) -> void:
	var target = VBOX.find_child(title, false, false)
	if !target:
		var label = Label.new()
		label.name = title
		label.text = "%s: %s" % [title, str(value)]
		VBOX.add_child(label)
	elif visible:
		target.text = "%s: %s" % [title, str(value)]
