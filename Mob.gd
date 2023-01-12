extends KinematicBody

#signal when player jumped on mob
signal squashed

# minimum speed of mob in m/s
export var min_speed = 10
# mximum speed of mob in m/s
export var max_speed = 20

var velocity = Vector3.ZERO

func _physics_process(delta):
	move_and_slide(velocity)

func initialize(start_position, player_position):
	
	#position mob to players positon and turn it so that it looks at player
	look_at_from_position(start_position, player_position, Vector3.UP)
	#rotate it randomly so that it doesnt move exactly towards the player
	rotate_y(rand_range(-PI/4, PI/4))
	
	#random speed 
	var random_speed = rand_range(min_speed, max_speed)
	#calculate forward velocity
	velocity = Vector3.FORWARD * random_speed
	#rotate it based onmob's Y rotation to move in the direction its lookinh
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	$AnimationPlayer.playback_speed = random_speed / min_speed


func squash():
	emit_signal("squashed")
	queue_free()

func _on_VisibilityNotifier_screen_exited():
	queue_free()
