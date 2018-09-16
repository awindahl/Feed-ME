extends "res://Engine/engine.gd";

var canMove = true
var direction = 0
var energy = 0
var size = Vector2(1,1)
var health = 10
var hitstun = 0
var holdtime = 0
var knockdir = Vector2(0,0)
const TYPE = "PLAYER"
var SPEED = 200

func _physics_process(delta):
	# init
	var mousePos = get_node("Camera2D").get_global_mouse_position()
	var myPosition = position
	var velocity = (mousePos - myPosition).normalized() * SPEED
	scale = size
	
	# handles collision, checks if colliding body is larger than you - if it is you take damage, if not you 'eat' it
	if hitstun > 0:
		hitstun -= 1
	
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if hitstun == 0 and size != null and body.size >= size and area.name  == "hitbox" and body.get("TYPE") == "ENEMY":
			hitstun = 10
			knockdir = global_transform.origin - body.global_transform.origin
			motion = knockdir.normalized()
			#size -= body.size/3 -- dont shrink
			health -= 1
		elif body.size < size and area.name  == "hitbox" and body.get("TYPE") == "ENEMY":
			size += body.size/4
			$eat.play()
			body.queue_free()
		
	# movement follows cursor unless enemy is larger, then knockback
	if (mousePos-position).length() > 5 and hitstun == 0 and holdtime == 0:
		move_and_slide(velocity * (scale.x/1.5))
		rotation = velocity.angle() + deg2rad(270)
	elif hitstun > 0:
		move_and_slide(motion*600*scale.x)
	
	# if you have more energy than 2, you can boost by clicking
	if energy < 100*scale.x/2 and not SPEED >= 500:
		energy += 1*scale.x/2
	elif SPEED >= 500 and energy >= 2:
		energy -= 0.5
	if energy <= 2:
		SPEED = 200
	
	# camera controls
	if $Camera2D.zoom.x/size.x< 0.5:
		$Camera2D.set_zoom(size)
	elif ($Camera2D.zoom.x/size.x) >= 1.5:
		$Camera2D.set_zoom(size)
		
	
	# sprite handing
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if area.name == "hitbox":
			if body.size >= size:
				$Sprite.frame = 3
				holdtime = 10
			elif body.size < size:
				holdtime = 10
				$Sprite.frame = 1
	if holdtime > 0:
		holdtime -= 1
	if holdtime == 0 and SPEED < 500:
		$Sprite.frame = 0
	elif holdtime == 0 and SPEED <= 500:
		$Sprite.frame = 2
		
	# death
	if health == 0:
		queue_free()
	
#  boost does NOT end when mouse is moved while button is HELD
func _input(event):
	if event.is_action_pressed("click") and energy > 2 and hitstun == 0:
		SPEED = 500
	elif event is InputEventMouseMotion and energy > 2 and holdtime == 0:
		SPEED = SPEED
	else:
		SPEED = 200
	
	# press space to shrink!
	if event.is_action_released("ui_accept") and size.x > 1:
		size.x = size.x/1.5
		size.y = size.y/1.5
		$Sprite.frame = 3
		holdtime = 10