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
	motion = movedir.normalized()

func _physics_process(delta):
	
	size = scale.ceil()

	for area in $vision.get_overlapping_areas():
		var body = area.get_parent()
		if body.get("TYPE") == "PLAYER" and body.size > size:
			motion = (global_transform.origin - body.global_transform.origin).normalized()
			SPEED = 2000
			$Sprite.frame = 1
			rotation = motion.angle() + deg2rad(270)
		elif body.get("TYPE") == "PLAYER" and body.size <= size and body.hitstun == 0:
			print(body.hitstun)
			motion = (global_transform.origin - body.global_transform.origin).normalized() * -1
			SPEED = 800
			$Sprite.frame = 2
			rotation = motion.angle() + deg2rad(270)
		else:
			$Sprite.frame = 0
			rotation = 0
			motion = movedir.normalized()
			SPEED = 700
	
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0 || is_on_wall():
		movedir = rand()
		rotation = 0
		motion = movedir.normalized()
		$Sprite.frame = 0
		movetimer = movetimer_length
		
	move_and_slide(motion*SPEED*(scale.x/6))
