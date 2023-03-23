extends Node

const HIGH_SCORE_FILE_NAME = "user://high_score.dat"

@export var mob_scene: PackedScene
var score



# Called when the node enters the scene tree for the first time.
func _ready():
	display_high_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	save_high_score()
	display_high_score()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$MainMusic.stop()
	$GameOverSound.play()
	


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$MainMusic.play()



func _on_mob_timer_timeout():
	# create a new mob scene instance
	var mob = mob_scene.instantiate()
	
	# choose a random location on Path2D
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	# set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# set the mob's position to a random location
	mob.position = mob_spawn_location.position
	
	# add some randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# choose the velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# spawn the mob by adding it to the main scene
	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func get_high_score() -> int:
	if FileAccess.file_exists(HIGH_SCORE_FILE_NAME):
		var high_score_file = FileAccess.open(HIGH_SCORE_FILE_NAME, FileAccess.READ)
		var high_score_data = JSON.parse_string(high_score_file.get_line())
		print("HSD: " + str(high_score_data))
		if high_score_data != null:
			return high_score_data.high_score
	return 0

func set_high_score(high_score):
	var high_score_data = {
		"high_score": high_score
	}
	var high_score_file = FileAccess.open(HIGH_SCORE_FILE_NAME, FileAccess.WRITE)
	high_score_file.store_line(JSON.stringify(high_score_data))
	high_score_file.close()


func display_high_score():
	$HUD/HighScore.text = str(get_high_score())


func save_high_score():
	if not FileAccess.file_exists(HIGH_SCORE_FILE_NAME):
		# Set HIGH SCORE as current score
		set_high_score(score)
	else:
		# Get HIGH SCORE from file
		# And then compare current score with high score
		# If score >= than high score, store it
		var high_score = get_high_score()
		
		if score >= high_score:
			set_high_score(score)
