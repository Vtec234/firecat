extends Node2D

# The objects spawned in this object's place after interacting
export var spawns = []

func _ready():
	self.add_to_group("interactable")
	
func interact():
	for s in spawns:
		var new_s = s.duplicate()
		self.add_child(new_s)
	
	self.remove_and_skip()