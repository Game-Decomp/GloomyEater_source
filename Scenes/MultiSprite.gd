tool
extends Node2D

export var frame = 0 setget set_frame

func set_frame(val):
	frame = val
	
	var i = 0
	for s in get_children():
		if i == frame:
			s.show()
		else:
			s.hide()
		i += 1
