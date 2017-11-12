extends Node2D

func _ready():
	self.add_to_group("interactable")
	if self.has_node("SpriteReplacer"):
		self.get_node("SpriteReplacer").set_hidden(true)
	for c in self.get_children():
		if c.get_type() == "RigidBody2D":
			c.set_mode(1) # MODE_STATIC
			c.set_hidden(true)
	
func interact():
	for c in self.get_children():
		if c.get_type() == "RigidBody2D":
			c.set_pos(self.get_global_pos() + c.get_pos())
			c.set_mode(0) # MODE_RIGID
			c.set_hidden(false)
			
	if self.has_node("SpriteReplacer"):
		var rpl = self.get_node("SpriteReplacer")
		rpl.set_pos(self.get_global_pos())
		rpl.set_scale(self.get_scale())
		rpl.set_hidden(false)
	
	self.remove_and_skip()