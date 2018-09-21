extends "res://Engine/engine.gd"

export var size = Vector2(1,1)
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
	
	scale = size

	for area in $vision.get_overlapping_areas():
		var body = area.get_parent()
		if body.get("TYPE") == "PLAYER":
			if body.size.x > size.x:
				motion = (global_transform.origin - body.global_transform.origin).normalized()
				SPEED = 2000
				$Sprite.frame = 1
				rotation = motion.angle() + deg2rad(270)
			elif body.size.x <= size.x and body.hitstun == 0:
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
