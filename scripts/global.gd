extends Node

var debug
var DEBUG_MODE = true


func debug_print(string: String) -> void:
	if DEBUG_MODE: print_rich("[color=green]%s[/color]" % string)
