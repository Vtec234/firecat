extends Node2D

var is_on_fire = false
const FIRE_SPREAD_DIST = 40

# Called whenever there appears a fire at position pos
func on_fire_nearby(pos):
	if (self.get_global_pos() - pos).length() < FIRE_SPREAD_DIST:
		self.is_on_fire = true
		self.remove_from_group("flammable")
		self.add_to_group("on_fire")
		var fire_prefab = self.get_tree().get_root().get_node("Game").get_node("Prefabs").get_node("FireAnim")
		print("spreading fire")
		var fire = fire_prefab.duplicate()
		self.add_child(fire)
		fire.set_pos(Vector2(0, 0))

func _ready():
	self.set_process(true)
	self.add_to_group("flammable")

func _process(dt):
	if self.is_on_fire:
		self.get_tree().call_group(0, "flammable", "on_fire_nearby", self.get_global_pos())