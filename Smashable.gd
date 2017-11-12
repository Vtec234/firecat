extends RigidBody2D

export var smash_threshold = 400
export var on_break_sprite = "res://kitchen/assets/oil_1.png"
export var empty_sprite = "res://kitchen/assets/empty_bottle.png"
export var spillage_limit = 3 # How many times it can spill before being destroyed

var times_spilled = 0
const FORCE_DAMPING = 20

func _ready():
	self.add_to_group("smashable")
	self.set_fixed_process(true)

func _fixed_process(delta):
	self.set_applied_force(self.get_applied_force() * (1 - min(delta * FORCE_DAMPING, 1)))

	if times_spilled < spillage_limit:
		var cols = self.get_colliding_bodies()
		for c in cols:
			if c.get_layer_mask() & 1 != 0: # If collider is a wall
				if self.get_linear_velocity().length() > smash_threshold:
					var spill_prefab = self.get_tree().get_root().get_node("Game").get_node("Prefabs").get_node("Flammable")
					var spill = spill_prefab.duplicate()
					spill.set_texture(load(on_break_sprite))
					spill.set_pos(self.get_global_pos())
					self.get_tree().get_root().get_node("Game").add_child(spill)
					times_spilled += 1
					spill.is_on_fire = true
	elif empty_sprite != "":
		self.get_node("Sprite").set_texture(load(empty_sprite))
	else:
		self.queue_free()