extends Area2D

@export var speed = 800

func _ready():
	set_as_top_level(true)

func _process(delta):
	position += (Vector2.RIGHT*speed).rotated(rotation) * delta
	Vector2(1,0)

#animated bullets
#func _physics_process(delta):
	#await (get_tree().create_timer(0.01))
	#set_physics_process(false)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	

func _on_body_entered(body):
	queue_free()
