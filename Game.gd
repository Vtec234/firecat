extends Node

enum Scene { MENU, SCORE, CREDITS, KITCHEN, LIVING_ROOM }
var scene = Scene.KITCHEN
var alarm_on = false
const BURNAGE_LIMIT = 1000
const FIRE_DEPT_DELAY = 60
var burnage_left = BURNAGE_LIMIT
var time_till_dept_arrival = 0
# Time in seconds from first fire to fire dept. arrival


onready var cam = self.get_node("Camera")
onready var cat = self.get_node("Cat")
onready var fd_meter_c = cam.get_node("MeterFD").get_node("MeterFDC")
onready var fd_meter_r = cam.get_node("MeterFD").get_node("MeterFDR")
onready var br_meter_c = cam.get_node("MeterBR").get_node("MeterBRC")
onready var br_meter_r = cam.get_node("MeterBR").get_node("MeterBRR")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.set_process(true)
	var sampl = preload("res://sounds/c23_gamejam.wav")
	
func _process(dt):
	# Adjust camera
	var cam_pos = cam.get_pos()
	cam.set_pos(Vector2(clamp(cat.get_pos().x - 640, -3800, 280), clamp(cat.get_pos().y - 620, 0, 720)))
	
	# Count fires
	var fires_started = self.get_tree().get_nodes_in_group("on_fire").size()
	if fires_started != 0 and alarm_on == false:
		alarm_on = true
		cam.get_node("MeterFD").set_hidden(false)
		cam.get_node("MeterBR").set_hidden(false)
		time_till_dept_arrival = FIRE_DEPT_DELAY
		
	burnage_left -= fires_started * dt
	
	# Update meters
	var br_scale = burnage_left/BURNAGE_LIMIT*20
	br_meter_c.set_scale(Vector2(br_scale, 1))
	br_meter_r.set_pos(Vector2(12 + br_scale*12, 0))
	
	var fd_scale = time_till_dept_arrival/FIRE_DEPT_DELAY*20
	fd_meter_c.set_scale(Vector2(fd_scale, 1))
	fd_meter_r.set_pos(Vector2(12 + fd_scale*12, 0))
	
	# Check win/lose condition
	time_till_dept_arrival = max(0, time_till_dept_arrival - dt)
	if alarm_on == true and time_till_dept_arrival == 0:
		print("Game over! You got " + String(burnage_left) + " points!")