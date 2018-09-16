extends "res://Engine/engine.gd"

var size = 0
var points = 1
var movetimer_length = 60
var movetimer = 0
var rundir
export var SPEED = 700
const TYPE = "ENEMY"

func _ready():
	movedir = rand()

func _physics_process(delta):
	
	size = scale

	for area in $vision.get_overlapping_areas():
		var body = area.get_parent()
		if body.get("TYPE") == "PLAYER" and body.size > size and body.hitstun == 0:
			motion = (global_transform.origin - body.global_transform.origin).normalized()
			SPEED = 2000
		elif body.get("TYPE") == "PLAYER" and body.size <= size:
			motion = (global_transform.origin - body.global_transform.origin).normalized() * -1
			SPEED = 800
		else:
			motion = movedir.normalized()
			SPEED = 700
	
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0 || is_on_wall():
		movedir = rand()
		movetimer = movetimer_length
		
	move_and_slide(motion*SPEED*(scale.x/6))
