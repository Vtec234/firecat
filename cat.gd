extends KinematicBody2D

var vel = Vector2(0, 0)
const FRICTION = 20
const MOVE_SPEED = 700
const GRAVITY = 5000
const JUMP_SPEED = 2000
const SMASH_COOLDOWN = 0.5
var smash_dir = Vector2(0, 0)
var try_smash = false
var time_till_smash = 0

func _ready():
	# Called every time the node is added to the scene.
	set_fixed_process(true)
	self.set_process_input(true)

func _input(ev):
	if ev.is_action_pressed("jump"):
		vel = Vector2(0, -JUMP_SPEED)
	elif ev.is_action("move_down"):
		pass
	elif ev.is_action("action"):
		if time_till_smash <= 0.001:
			try_smash = true
			time_till_smash = SMASH_COOLDOWN
			
	if ev.type == InputEvent.MOUSE_MOTION:
		smash_dir = (ev.pos - self.get_global_pos()).normalized()
		self.update()
			
func _draw():
	self.draw_line(smash_dir * 70, smash_dir * 110, Color(0xffffff), 4)
	pass
	
func _fixed_process(delta):
	if Input.is_action_pressed("move_left"):
		vel.x = -MOVE_SPEED
	if Input.is_action_pressed("move_right"):
		vel.x = MOVE_SPEED
	vel.x *= 1 - min(delta * FRICTION, 1)
	if time_till_smash > 0.001:
		self.get_children()[0].set_animation("swipe")
		vel.x = 0
	elif abs(vel.x) > 0.005:
		if vel.x > 0.005:
			self.get_children()[0].set_animation("walking")
			self.get_children()[0].set_flip_h(false)
		else:
			self.get_children()[0].set_animation("walking")
			self.get_children()[0].set_flip_h(true)
	else:
		self.get_children()[0].set_animation("still")
	vel.y += GRAVITY * delta
	
	var motion = self.move(vel * delta)
	if self.is_colliding():
		var n = self.get_collision_normal()
		motion = n.slide(motion)
		vel = n.slide(vel)
		self.move(motion)
		
	if time_till_smash >= 0.001:
		time_till_smash = max(0, time_till_smash - delta)
		
	if try_smash == true:
		var space_state = get_world_2d().get_direct_space_state()
		# use global coordinates, not local to node
		var result = space_state.intersect_ray(self.get_global_pos(), self.get_global_pos() + 1000*smash_dir, [self])
		if not result.empty():
			if result.collider.get_layer_mask() & 2 != 0:
				result.collider.set_applied_force(smash_dir * 2000000 *delta)
				print(result.collider.get_applied_force())
		try_smash = false