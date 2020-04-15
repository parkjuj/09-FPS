extends Node

class_name objects

func get_interaction_text():
	return "Interact"

func interact():
	print("Interacted with %s" % name)
