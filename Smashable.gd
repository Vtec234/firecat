extends RigidBody2D

export var SMASH_THRESHOLD = 400
const FORCE_DAMPING = 2

func _ready():
	self.set_fixed_process(true)

func _fixed_process(delta):
	self.set_applied_force(self.get_applied_force() * (1 - min(delta * FORCE_DAMPING, 1)))

	var cols = self.get_colliding_bodies()
	for c in cols:
		if c.get_layer_mask() & 1 != 0:
			if self.get_linear_velocity().length() > SMASH_THRESHOLD:
				print("oil smashed")