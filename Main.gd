extends Node

export (PackedScene) var mob_scene

func _ready():
	randomize()
	$UserInterface/Retry.hide()

func _on_MobTimer_timeout():
	#create an instance of mob
	var mob = mob_scene.instance()
	
	#random location on spawn path
	var mob_spawn_location=$SpawnPath/SpawnLocation
	mob_spawn_location.unit_offset = randf()
	
	var player_position = $Player.transform.origin
	mob.initialize(mob_spawn_location.translation, player_position)
	
	add_child(mob)
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")


func _on_Player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()
