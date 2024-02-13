extends Sprite2D

var can_fire = true

var bullet = preload("res://sprites/projectiles/Bullet.png")

func _ready():
	set_as_top_level(true)
	#var cursor_texture = preload("res://hud/mouse cursor.png")
	#Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW)

func _physics_process(delta):
	position.x =lerp(position.x, get_parent().position.x + 1.5, 0.6)
	position.y =lerp(position.y, get_parent().position.y - 9, 0.6)
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	

	
	if Input.is_action_just_pressed("shoot") and can_fire:
		var bullet_instance = bullet.instantiate()
		bullet_instance.rotation = rotation
		bullet_instance.global_position = $Marker2D.global_position
		get_parent().add_child(bullet_instance)
		can_fire = false
		await get_tree().create_timer(0.9).timeout
		can_fire = true
	

