extends KinematicBody

#signal when player dies
signal hit

#how fast player moves in m/s
export var speed = 15
#downward acceleration when in air, m/s^2
export var fall_acceleration = 75
#vertical impulse applied when jumped in m/s
export var jump_impulse = 20
#vertical impulse appliced when bouncing over a mob in m/s
export var bounce_impulse = 16

var velocity = Vector3.ZERO 

func _physics_process(delta):
	#local variable to denote character direction
	var direction = Vector3.ZERO
	
	#updating direction according to the input
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
		$AnimationPlayer.playback_speed = 4
	else:
		$AnimationPlayer.playback_speed = 1
	
	#Ground Velocity
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	#jumping the character
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y += jump_impulse
	
	#vertical velocity
	velocity.y -= fall_acceleration * delta
	#moving the character
	velocity = move_and_slide(velocity, Vector3.UP)
	
	#for collision detection
	for index in range(get_slide_count()):
		#checks for every collision in this frame
		var collision = get_slide_collision(index)
		#if collided
		if collision.collider.is_in_group("mob"):
			var mob = collision.collider
			#we check that we are hitting it from above
			if Vector3.UP.dot(collision.normal) > 0.1:
				#if so, we squash the mob and bounce a lil
				mob.squash()
				velocity.y = bounce_impulse
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func die():
	emit_signal("hit")
	queue_free()

func _on_Mob_Detector_body_entered(body):
	die()
