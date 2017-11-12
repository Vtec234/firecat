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
		c.set_pos(c.get_global_pos())
		c.set_scale(self.get_scale() * c.get_scale())
		
		if c.get_type() == "RigidBody2D":
			c.set_mode(0) # MODE_RIGID
			c.set_hidden(false)
	
	if self.has_node("SpriteReplacer"):
		var rpl = self.get_node("SpriteReplacer")
		rpl.set_hidden(false)
		
	
		
	if self.has_node("stovetop"):
		self.get_node("stovetop").on_fire_nearby(self.get_node("stovetop").get_global_pos())
	
	self.remove_and_skip()