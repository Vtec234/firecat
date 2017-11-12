extends Node2D

var is_on_fire = false
const FIRE_SPREAD_COEFF = 0.035 # How easily fire spreads

# Called whenever there appears a fire at position pos
func on_fire_nearby(pos):
	var dist = (self.get_global_pos() - pos).length()
	if rand_range(0, dist) < FIRE_SPREAD_COEFF:
		self.is_on_fire = true
		self.remove_from_group("flammable")
		self.add_to_group("on_fire")
		var fire_prefab = self.get_tree().get_root().get_node("Game").get_node("Prefabs").get_node("FireAnim2")
		var fire = fire_prefab.duplicate()
		fire.get_node("SamplePlayer2D").play("fire_low")
		fire.set_pos(Vector2(0, 0))
		self.add_child(fire)

func _ready():
	self.set_process(true)
	self.add_to_group("flammable")

func _process(dt):
	if self.is_on_fire:
		self.get_tree().call_group(0, "flammable", "on_fire_nearby", self.get_global_pos())