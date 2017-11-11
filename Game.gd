extends Node

enum Scene { MENU, SCORE, CREDITS, KITCHEN, LIVING_ROOM }
var scene = Scene.KITCHEN
var fires_started = 0
var burnt_meter = 0
var dept_arrival_time = 0
# Time in seconds from first fire to fire dept. arrival
const FIRE_DEPT_DELAY = 300

onready var cam = self.get_node("Camera")
onready var cat = self.get_node("Cat")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.set_process(true)
	
func _process(dt):
	var cam_pos = cam.get_pos()
	cam.set_pos(Vector2(min(cat.get_pos().x - 640, 0), cam_pos.y))