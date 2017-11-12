extends KinematicBody2D

var vel = Vector2(0, 0)
const FRICTION = 20
const MOVE_SPEED = 700
const GRAVITY = 5000
const JUMP_SPEED = 2000
const SMASH_COOLDOWN = 0.5
const INTERACTION_DIST = 150
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
		print(ev.pos)
		smash_dir = (ev.pos + self.get_tree().get_root().get_node("Game").get_node("Camera").get_global_pos() - self.get_global_pos()).normalized()
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
		var smashables = self.get_tree().get_nodes_in_group("smashable")
		var closest = smashables[0]
		var closest_type = "smashable"
		var pos = self.get_global_pos()
		var dist = (closest.get_global_pos() - pos).length()
		for s in smashables:
			if (s.get_global_pos() - pos).length() < dist:
				closest = s
				dist = (closest.get_global_pos() - pos).length()
		for i in self.get_tree().get_nodes_in_group("interactable"):
			if (i.get_global_pos() - pos).length() < dist:
				closest = i
				dist = (closest.get_global_pos() - pos).length()
				closest_type = "interactable"
		if dist < INTERACTION_DIST:
			if closest_type == "smashable":
				closest.set_applied_force(smash_dir * 800000 * delta)
			else:
				closest.interact()
				
		try_smash = false