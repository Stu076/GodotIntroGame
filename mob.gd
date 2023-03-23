extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	#var mob_types = $AnimatedSprite2D.get_sprite_frames().get_animation_names()
	#$AnimatedSprite2D.animation = mob_types[randi() % mob_types.size()]
	# TODO: need to create 3 separate mobs, because of weird shapes the
	# CollisionShape2D is mismatched
	$AnimatedSprite2D.animation = "walk"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
