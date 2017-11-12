extends Node

enum Scene { MENU, SCORE, CREDITS, KITCHEN, LIVING_ROOM }
var scene = Scene.KITCHEN
var alarm_on = false
var burnt_meter = 0
var time_till_dept_arrival = 0
# Time in seconds from first fire to fire dept. arrival
const FIRE_DEPT_DELAY = 300

onready var cam = self.get_node("Camera")
onready var cat = self.get_node("Cat")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.set_process(true)
	
func _process(dt):
	# Adjust camera
	var cam_pos = cam.get_pos()
	cam.set_pos(Vector2(min(cat.get_pos().x - 640, 280), cam_pos.y))
	
	# Count fires
	var fires_started = self.get_tree().get_nodes_in_group("on_fire").size()
	if fires_started != 0:
		alarm_on = true
		time_till_dept_arrival = FIRE_DEPT_DELAY
		
	burnt_meter += fires_started * dt * 10
	
	# Check win/lose condition
	time_till_dept_arrival = max(0, time_till_dept_arrival - dt)
	if alarm_on == true and time_till_dept_arrival == 0:
		print("Game over! You got " + String(burnt_meter) + " points!")